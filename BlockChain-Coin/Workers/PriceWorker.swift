//
//  PriceWorker.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/12/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

enum PriceStoreResult<T> {
    case success(result: T)
    case failure(error: PriceStoreError)
}

enum PriceStoreError: Equatable, Error {
    static func ==(lhs: PriceStoreError, rhs: PriceStoreError) -> Bool {
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

typealias PriceStoreGetPriceHistoryCompletionHandler = (PriceStoreResult<[PriceHistoryItemModel]>) -> Void

protocol PriceStore {
    func fetchPriceHistory(days: UInt?, currency: String, completion: @escaping PriceStoreGetPriceHistoryCompletionHandler)
}

class PriceWorker {
    private let store: PriceStore
    
    init(store: PriceStore) {
        self.store = store
    }
    
    func fetchPriceHistory(days: UInt?, currency: String, completion: @escaping PriceStoreGetPriceHistoryCompletionHandler) {
        store.fetchPriceHistory(days: days, currency: currency) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
