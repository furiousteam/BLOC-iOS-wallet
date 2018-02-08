//
//  MinerWorker.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

enum MinerStoreResult<T> {
    case success(result: T)
    case failure(error: MinerStoreError)
}

enum MinerStoreError: Equatable, Error {
    case unknown
}

typealias MinerStoreStopCompletionHandler = (MinerStoreResult<Bool>) -> Void

protocol MinerStore: class {
    var delegate: MinerStoreDelegate? { get }

    func mine(job: JobModel, threadLimit: Int, delegate: MinerStoreDelegate?)
    func stop(completion: @escaping MinerStoreStopCompletionHandler)
    func evaluate(job: JobModel, hash: Data) -> Bool
}

protocol MinerStoreDelegate {
    func didComplete(job: JobModel)
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
    
    func evaluate(job: JobModel, hash: Data) -> Bool {
        return store.evaluate(job: job, hash: hash)
    }
}
