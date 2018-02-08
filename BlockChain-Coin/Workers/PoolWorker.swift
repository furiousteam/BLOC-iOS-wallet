//
//  PoolWorker.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

enum PoolStoreResult<T> {
    case success(result: T)
    case failure(error: PoolStoreError)
}

enum PoolStoreError: Equatable, Error {
    case unknown
    case couldNotConnect
    case alreadyConnected
    case alreadyDisconnected
}

typealias PoolStoreConnectCompletionHandler = (PoolStoreResult<Bool>) -> Void
typealias PoolStoreDisconnectCompletionHandler = (PoolStoreResult<Bool>) -> Void
typealias PoolStoreSubmitJobCompletionHandler = (PoolStoreResult<Bool>) -> Void

protocol PoolStore {
    func connect(completion: @escaping PoolStoreConnectCompletionHandler)
    func disconnect(completion: @escaping PoolStoreDisconnectCompletionHandler)
    func submit(job: JobModel, completion: @escaping PoolStoreSubmitJobCompletionHandler)
}

class PoolWorker {
    private let store: PoolStore
    
    init(store: PoolStore) {
        self.store = store
    }
    
    func connect(completion: @escaping PoolStoreConnectCompletionHandler) {
        store.connect { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func disconnect(completion: @escaping PoolStoreDisconnectCompletionHandler) {
        store.disconnect { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func submit(job: JobModel, completion: @escaping PoolStoreSubmitJobCompletionHandler) {
        store.submit(job: job) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
