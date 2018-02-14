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
    case unknown
    case couldNotConnect
    case alreadyConnected
    case alreadyDisconnected
    case couldNotDisconnect
    case couldNotCreateWallet
}

typealias WalletStoreListWalletsCompletionHandler = (WalletStoreResult<[WalletModel]>) -> Void
typealias WalletStoreAddWalletCompletionHandler = (WalletStoreResult<String>) -> Void

protocol WalletStore {
    func addWallet(keyPair: KeyPair, address: String?, completion: @escaping WalletStoreAddWalletCompletionHandler)

    func generateSeed() -> Seed?
    func generateKeyPair(seed: Seed) -> KeyPair?
    
    func listWallets(completion: @escaping WalletStoreListWalletsCompletionHandler)
}

protocol WalletStoreDelegate: class {
    func walletStoreDidConnect()
    func walletStoreDidFailToConnect(error: WalletStoreError)
    func walletStoreDidDisconnect()
    func walletStoreDidFailToDisconnectDisconnect(error: WalletStoreError)
    func walletStore(didReceiveUnknownResponse: [String: Any])
    func walletStoreDidAddWallet()
}

extension WalletStoreDelegate {
    func walletStoreDidConnect() { }
    func walletStoreDidFailToConnect(error: WalletStoreError) { }
    func walletStoreDidDisconnect() { }
    func walletStoreDidFailToDisconnectDisconnect(error: WalletStoreError) { }
    func walletStore(didReceiveUnknownResponse: [String: Any]) { }
    func walletStoreDidAddWallet() { }
}

class WalletWorker {
    private let store: WalletStore
    
    init(store: WalletStore) {
        self.store = store
    }

    // Remote
        
    func addWallet(keyPair: KeyPair, address: String?, completion: @escaping WalletStoreAddWalletCompletionHandler) {
        store.addWallet(keyPair: keyPair, address: address) { result in
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
