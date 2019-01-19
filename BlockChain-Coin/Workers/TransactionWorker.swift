//
//  TransactionWorker.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

enum TransactionStoreResult<T> {
    case success(result: T)
    case failure(error: TransactionStoreError)
}

enum TransactionStoreError: Equatable, Error {
    case unknown
    case invalidPaymentId
    case invalidExtraNonceSize
    case feeTooLow
    case invalidDestinationAddresses
    case invalidDestinationAmount
    case destinationEmpty
}

typealias TransactionStoreSendCompletionHandler = (TransactionStoreResult<Bool>) -> Void

protocol TransactionStore {
    func send(destinations: [TransactionDestinationModel], mixin: UInt, paymentId: String?, fee: Double, keyPair: KeyPair, completion: @escaping TransactionStoreSendCompletionHandler)
}

class TransactionWorker {
    private let store: TransactionStore
    
    init(store: TransactionStore) {
        self.store = store
    }
    
    func send(destinations: [TransactionDestinationModel], mixin: UInt, paymentId: String?, fee: Double, keyPair: KeyPair, completion: @escaping TransactionStoreSendCompletionHandler) {
        store.send(destinations: destinations, mixin: mixin, paymentId: paymentId, fee: fee, keyPair: keyPair) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
