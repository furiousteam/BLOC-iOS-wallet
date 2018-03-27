//
//  WalletWorker.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 10/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

enum WalletStoreResult<T> {
    case success(result: T)
    case failure(error: WalletStoreError)
}

enum WalletStoreError: Equatable, Error {
    static func ==(lhs: WalletStoreError, rhs: WalletStoreError) -> Bool {
        switch lhs {
        case .raw(let lhsString):
            switch rhs {
            case .raw(let rhsString):
                return lhsString == rhsString
            default:
                return false
            }
        default:
            return lhs == rhs
        }
    }
    
    case unknown
    case couldNotConnect
    case alreadyConnected
    case alreadyDisconnected
    case couldNotDisconnect
    case couldNotCreateWallet
    case raw(string: String)
    
    var localizedDescription: String {
        switch self {
        case .raw(let string):
            return string
        default:
            return R.string.localizable.error_unknown()
        }
    }
}

typealias WalletStoreListWalletsCompletionHandler = (WalletStoreResult<[WalletModel]>) -> Void
typealias WalletStoreAddWalletCompletionHandler = (WalletStoreResult<String>) -> Void
typealias WalletStoreGetBalanceAndTransactionsCompletionHandler = (WalletStoreResult<WalletDetails>) -> Void
typealias WalletStoreGetKeysCompletionHandler = (WalletStoreResult<WalletKeys>) -> Void
typealias WalletStoreTransferCompletionHandler = (WalletStoreResult<String>) -> Void
typealias WalletStoreGetAllWalletDetailsCompletionHandler = (WalletStoreResult<[WalletModel]>) -> Void

protocol WalletStore {
    func addWallet(keyPair: KeyPair, uuid: UUID, secretKey: String?, password: String?, address: String?, name: String, details: WalletDetails?, completion: @escaping WalletStoreAddWalletCompletionHandler)
    func getBalanceAndTransactions(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetBalanceAndTransactionsCompletionHandler)
    func getAllWalletDetails(wallets: [WalletModel], completion: @escaping WalletStoreGetAllWalletDetailsCompletionHandler)
    func getKeys(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetKeysCompletionHandler)
    func transfer(wallet: WalletModel, password: String, destination: String, amount: Int64, fee: UInt64, anonymity: UInt64, unlockHeight: UInt64?, paymentId: String?, completion: @escaping WalletStoreTransferCompletionHandler)
    
    func generateSeed() -> Seed?
    func generateKeyPair(seed: Seed) -> KeyPair?
    
    func listWallets(completion: @escaping WalletStoreListWalletsCompletionHandler)
}

class WalletWorker {
    private let store: WalletStore
    
    init(store: WalletStore) {
        self.store = store
    }

    // Remote
        
    func addWallet(keyPair: KeyPair, uuid: UUID, secretKey: String?, password: String?, address: String?, name: String, details: WalletDetails?, completion: @escaping WalletStoreAddWalletCompletionHandler) {
        store.addWallet(keyPair: keyPair, uuid: uuid, secretKey: secretKey, password: password, address: address, name: name, details: details) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getBalanceAndTransactions(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetBalanceAndTransactionsCompletionHandler) {
        store.getBalanceAndTransactions(wallet: wallet, password: password) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getAllWalletDetails(wallets: [WalletModel], completion: @escaping WalletStoreGetAllWalletDetailsCompletionHandler) {
        store.getAllWalletDetails(wallets: wallets) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getKeys(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetKeysCompletionHandler) {
        store.getKeys(wallet: wallet, password: password) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func transfer(wallet: WalletModel, password: String, destination: String, amount: Int64, fee: UInt64, anonymity: UInt64, unlockHeight: UInt64?, paymentId: String?, completion: @escaping WalletStoreTransferCompletionHandler) {
        store.transfer(wallet: wallet, password: password, destination: destination, amount: amount, fee: fee, anonymity: anonymity, unlockHeight: unlockHeight, paymentId: paymentId) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    // Local
    
    func generateSeed() -> Seed? {
        return store.generateSeed()
    }
    
    func generateKeyPair(seed: Seed) -> KeyPair? {
        return store.generateKeyPair(seed: seed)
    }
    
    func listWallets(completion: @escaping WalletStoreListWalletsCompletionHandler) {
        store.listWallets { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
