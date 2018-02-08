//
//  CryptonightMiner.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

class CryptonightMiner: MinerStore {    
    var threads: [Thread] = []
    
    var delegate: MinerStoreDelegate?
    
    let jobSemaphore = DispatchSemaphore(value: 1)
    var job: JobModel?

    let statsSemaphore = DispatchSemaphore(value: 1)
    var stats = Stats(hashes: 0, submittedHashes: 0)

    func mine(job: JobModel, threadLimit: Int, delegate: MinerStoreDelegate?) {
        self.delegate = delegate
        self.job = job
        
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
        let hasher = HashContext()
        
        while !Thread.current.isCancelled {
            autoreleasepool {
                hash(with: hasher)
            }
        }
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
        
        let now = Date()
        
        if (now.timeIntervalSince(stats.lastUpdate) >= 0.1) {
            let s = self.stats
            
            DispatchQueue.main.async {
                self.delegate?.didUpdate(stats: s)
            }
            
            stats.lastUpdate = now
            stats.hashes = 0
        }
        
        statsSemaphore.signal()
        
        if evaluate(job: job, hash: result) {
            delegate?.didComplete(job: Job(id: job.id, jobId: job.jobId, blob: result, target: UInt64(currentNonce)))
            
            statsSemaphore.wait()
            
            stats.submittedHashes += 1
            
            DispatchQueue.main.async {
                self.delegate?.didUpdate(stats: self.stats)
            }
            
            statsSemaphore.signal()
        }
    }
    
    func stop(completion: @escaping MinerStoreStopCompletionHandler) {
        threads.forEach { $0.cancel() }
        threads = []
        
        completion(.success(result: true))
    }
    
    func evaluate(job: JobModel, hash: Data) -> Bool {
        let start = 24
        let sd = hash.subdata(in: start ..< start + MemoryLayout<UInt64>.size)
        let v = sd.withUnsafeBytes { (a: UnsafePointer<UInt64>) -> UInt64 in a.pointee }
        return v < job.target
    }
}
