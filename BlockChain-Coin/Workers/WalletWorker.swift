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
}

typealias WalletStoreConnectCompletionHandler = (WalletStoreResult<Bool>) -> Void

protocol WalletStore {
    var delegate: WalletStoreDelegate? { get set }
    
    func connect(host: String, port: Int)
    func disconnect()
}

protocol WalletStoreDelegate: class {
    //func walletStore(store: WalletStore, didCreateAddress: )
    
    func walletStoreDidConnect()
    func walletStoreDidFailToConnect(error: WalletStoreError)
    func walletStoreDidDisconnect()
    func walletStoreDidFailToDisconnectDisconnect(error: WalletStoreError)
    func walletStore(didReceiveUnknownResponse: [String: Any])
}

class WalletWorker {
    private let store: WalletStore
    
    init(store: WalletStore) {
        self.store = store
    }

    func connect(host: String, port: Int) {
        store.connect(host: host, port: port)
    }
    
    func disconnect() {
        store.disconnect()
    }
}
