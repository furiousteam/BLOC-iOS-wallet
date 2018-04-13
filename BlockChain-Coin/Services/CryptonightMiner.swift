//
//  CryptonightMiner.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class CryptonightMiner: MinerStore {
    static let defaultMiningPools: [MiningPool] = [ MiningPool(host: "http://blockchain-coin.us", port: 4444, stats: nil) ]
    
    var threads: [Thread] = []
    
    var delegate: MinerStoreDelegate?
        
    let jobSemaphore = DispatchSemaphore(value: 1)
    var job: JobModel? {
        didSet(oldVal) {
            if let oldId = oldVal?.id, job?.id.isEmpty == true {
                job?.id = oldId
            }
            
            log.info("New job")
        }
        
    }

    let statsSemaphore = DispatchSemaphore(value: 1)
    var stats = Stats(hashes: 0, submittedHashes: 0, allTimeHashes: 0)

    func mine(job: JobModel, threadLimit: Int, delegate: MinerStoreDelegate?) {
        self.delegate = delegate
        self.job = job
        
        threads.forEach {
            $0.cancel()
        }
        
        threads = []
        
        let threadCount = max(min(ProcessInfo.processInfo.activeProcessorCount, threadLimit), 1)

        (0 ..< threadCount).forEach { thread in
            let t = Thread(block: mine)
            t.name = "Mining Thread #\(thread + 1)"
            t.qualityOfService = .userInitiated
            t.start()
            
            threads.append(t)
        }
    }
    
    fileprivate func mine() {
        var hasher: HashContext? = HashContext()
        
        while !Thread.current.isCancelled {
            autoreleasepool {
                if let hasher = hasher {
                    hash(with: hasher)
                }
            }
        }
        
        hasher = nil
        
        Thread.exit()
    }
    
    private func hash(with hasher: HashContext) {
        jobSemaphore.wait()
        
        guard var job = job else {
            jobSemaphore.signal()
            return
        }
        
        job.nonce += 1

        let blob = job.blob
        let currentNonce = job.nonce
        
        jobSemaphore.signal()
        
        let result = hasher.hashData(blob)
        
        delegate?.didHash()
        
        statsSemaphore.wait()
        
        stats.hashes += 1
        stats.allTimeHashes += 1
        
        let now = Date()
        
        if (now.timeIntervalSince(stats.lastUpdateDispatch) >= 0.1) {
            let s = self.stats
            
            DispatchQueue.main.async {
                self.delegate?.didUpdate(stats: s)
            }
            
            stats.lastUpdateDispatch = now
        }
        
        if (now.timeIntervalSince(stats.lastUpdate) >= 30) {
            stats.hashes = 0
            stats.lastUpdate = now
            
            log.info("Still mining... \(job.jobId) - Current nonce: \(job.nonce)")
        }
        
        statsSemaphore.signal()
        
        if evaluate(job: job, hash: result) {
            delegate?.didComplete(id: job.id, jobId: job.jobId, result: result, nonce: currentNonce)
            
            statsSemaphore.wait()
            
            stats.submittedHashes += 1
            
            DispatchQueue.main.async {
                self.delegate?.didUpdate(stats: self.stats)
            }
            
            statsSemaphore.signal()
        }
    }
    
    func stop(completion: @escaping MinerStoreStopCompletionHandler) {
        threads.forEach {
            $0.cancel()
        }
        
        threads = []
        
        completion(.success(result: true))
    }
    
    func updateJob(job: JobModel) {
        self.job = job
    }
    
    func evaluate(job: JobModel, hash: Data) -> Bool {
        let start = 24
        let sd = hash.subdata(in: start ..< start + MemoryLayout<UInt64>.size)
        let v = sd.withUnsafeBytes { (a: UnsafePointer<UInt64>) -> UInt64 in a.pointee }
        return v < job.target
    }
    
    func fetchSettings(completion: @escaping MinerStoreSettingsCompletionHandler) {
        do {
            guard let data = KeychainWrapper.standard.data(forKey: "miningSettings"), let settingsData = NSKeyedUnarchiver.unarchiveObject(with: data) as? Data else {
                completion(.failure(error: .couldNotFetchSettings))
                return
            }
            
            let settings = try JSONDecoder().decode(MiningSettings.self, from: settingsData)
            
            completion(.success(result: settings))
        } catch {
            completion(.failure(error: .couldNotFetchSettings))
        }
    }
    
    func saveSettings(settings: MiningSettings) {
        do {
            let settingsData = try JSONEncoder().encode(settings)
            let data = NSKeyedArchiver.archivedData(withRootObject: settingsData)
            KeychainWrapper.standard.set(data, forKey: "miningSettings")
        } catch {
            log.error("Could not save mining settings")
        }
    }
    
}
