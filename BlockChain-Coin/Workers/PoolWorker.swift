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
    case cantReadData
}

typealias PoolStoreConnectCompletionHandler = (PoolStoreResult<Bool>) -> Void
typealias PoolStoreDisconnectCompletionHandler = (PoolStoreResult<Bool>) -> Void
typealias PoolStoreLoginCompletionHandler = (PoolStoreResult<JobModel>) -> Void
typealias PoolStoreSubmitJobCompletionHandler = (PoolStoreResult<JobModel>) -> Void

protocol PoolStore {
    func connect(host: String, port: Int, completion: @escaping PoolStoreConnectCompletionHandler)
    func disconnect(completion: @escaping PoolStoreDisconnectCompletionHandler)
    func login(username: String, password: String, completion: @escaping PoolStoreLoginCompletionHandler)
    func submit(id: String, jobId: String, result: Data, nonce: UInt32, completion: @escaping PoolStoreSubmitJobCompletionHandler)
}

class PoolWorker {
    private let store: PoolStore
    
    init(store: PoolStore) {
        self.store = store
    }
    
    func connect(host: String, port: Int, completion: @escaping PoolStoreConnectCompletionHandler) {
        store.connect(host: host, port: port) { result in
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
    
    func login(username: String, password: String, completion: @escaping PoolStoreLoginCompletionHandler) {
        store.login(username: username, password: password) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func submit(id: String, jobId: String, result: Data, nonce: UInt32, completion: @escaping PoolStoreSubmitJobCompletionHandler) {
        store.submit(id: id, jobId: jobId, result: result, nonce: nonce) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
