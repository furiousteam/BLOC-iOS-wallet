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

typealias MinerStoreStartCompletionHandler = (MinerStoreResult<Bool>) -> Void
typealias MinerStoreStopCompletionHandler = (MinerStoreResult<Bool>) -> Void
typealias MinerStoreEvaluateCompletionHandler = (MinerStoreResult<Bool>) -> Void

protocol MinerStore {
    func start(threadCount: Int, completion: @escaping MinerStoreStartCompletionHandler)
    func stop(completion: @escaping MinerStoreStopCompletionHandler)
    func evaluate(job: JobModel, hash: Data, completion: @escaping MinerStoreEvaluateCompletionHandler)
}

class MinerWorker {
    private let store: MinerStore
    
    init(store: MinerStore) {
        self.store = store
    }
    
    func start(threadCount: Int, completion: @escaping MinerStoreStartCompletionHandler) {
        store.start(threadCount: threadCount) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func stop(completion: @escaping MinerStoreStopCompletionHandler) {
        store.stop { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func evaluate(job: JobModel, hash: Data, completion: @escaping MinerStoreEvaluateCompletionHandler) {
        store.evaluate(job: job, hash: hash) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
