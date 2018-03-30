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
    case couldNotFetchPools
    
    var localizedDescription: String {
        switch self {
        case .couldNotConnect:
            return R.string.localizable.mining_could_not_connect()
        default:
            return R.string.localizable.error_unknown()
        }
    }
}

typealias PoolStoreConnectCompletionHandler = (PoolStoreResult<Bool>) -> Void
typealias PoolStoreDisconnectCompletionHandler = (PoolStoreResult<Bool>) -> Void
typealias PoolStoreLoginCompletionHandler = (PoolStoreResult<JobModel>) -> Void
typealias PoolStoreSubmitJobCompletionHandler = (PoolStoreResult<JobModel>) -> Void
typealias PoolStoreListCompletionHandler = (PoolStoreResult<[MiningPoolModel]>) -> Void
typealias PoolStoreStatsCompletionHandler = (PoolStoreResult<MiningPoolModel>) -> Void
typealias PoolStoreStatsMultipleCompletionHandler = (PoolStoreResult<[MiningPoolModel]>) -> Void

protocol PoolStore {
    func connect(host: String, port: Int, completion: @escaping PoolStoreConnectCompletionHandler)
    func disconnect(completion: @escaping PoolStoreDisconnectCompletionHandler)
    func login(username: String, password: String, completion: @escaping PoolStoreLoginCompletionHandler)
    func submit(id: String, jobId: String, result: Data, nonce: UInt32, completion: @escaping PoolStoreSubmitJobCompletionHandler)
    func listPools(completion: @escaping PoolStoreListCompletionHandler)
    func addPool(pool: MiningPool)
    func stats(pool: MiningPoolModel, completion: @escaping PoolStoreStatsCompletionHandler)
    func stats(pools: [MiningPoolModel], completion: @escaping PoolStoreStatsMultipleCompletionHandler)
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
    
    func listPools(completion: @escaping PoolStoreListCompletionHandler) {
        store.listPools { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func addPool(pool: MiningPool) {
        store.addPool(pool: pool)
    }
    
    func stats(pool: MiningPoolModel, completion: @escaping PoolStoreStatsCompletionHandler) {
        store.stats(pool: pool) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func stats(pools: [MiningPoolModel], completion: @escaping PoolStoreStatsMultipleCompletionHandler) {
        store.stats(pools: pools) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
