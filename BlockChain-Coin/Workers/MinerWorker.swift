//
//  MinerWorker.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

enum MinerStoreResult<T> {
    case success(result: T)
    case failure(error: MinerStoreError)
}

enum MinerStoreError: Equatable, Error {
    case unknown
    case couldNotSaveSettings
    case couldNotFetchSettings
}

typealias MinerStoreStopCompletionHandler = (MinerStoreResult<Bool>) -> Void
typealias MinerStoreSettingsCompletionHandler = (MinerStoreResult<MiningSettings>) -> Void

protocol MinerStore: class {
    var delegate: MinerStoreDelegate? { get }

    func mine(job: JobModel, threadLimit: Int, delegate: MinerStoreDelegate?)
    func stop(completion: @escaping MinerStoreStopCompletionHandler)
    func updateJob(job: JobModel)
    func evaluate(job: JobModel, hash: Data) -> Bool
    func saveSettings(settings: MiningSettings)
    func fetchSettings(completion: @escaping MinerStoreSettingsCompletionHandler)
}

protocol MinerStoreDelegate {
    func didComplete(id: String, jobId: String, result: Data, nonce: UInt32)
    func didHash()
    func didUpdate(stats: StatsModel)
}

class MinerWorker {
    private let store: MinerStore
    
    init(store: MinerStore) {
        self.store = store
    }
    
    func mine(job: JobModel, threadLimit: Int, delegate: MinerStoreDelegate?) {
        store.mine(job: job, threadLimit: threadLimit, delegate: delegate)
    }
    
    func stop(completion: @escaping MinerStoreStopCompletionHandler) {
        store.stop { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func updateJob(job: JobModel) {
        store.updateJob(job: job)
    }
    
    func evaluate(job: JobModel, hash: Data) -> Bool {
        return store.evaluate(job: job, hash: hash)
    }
    
    func saveSettings(settings: MiningSettings) {
        store.saveSettings(settings: settings)
    }

    func fetchSettings(completion: @escaping MinerStoreSettingsCompletionHandler) {
        store.fetchSettings { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
