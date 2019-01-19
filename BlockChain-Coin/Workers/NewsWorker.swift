//
//  NewsWorker.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

enum NewsStoreResult<T> {
    case success(result: T)
    case failure(error: NewsStoreError)
}

enum NewsStoreError: Equatable, Error {
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return R.string.localizable.list_news_error_no_news()
        }
    }
}

typealias NewsStoreListCompletionHandler = (NewsStoreResult<[NewsModel]>) -> Void

protocol NewsStore {
    func listNews(completion: @escaping NewsStoreListCompletionHandler)
}

class NewsWorker {
    private let store: NewsStore
    
    init(store: NewsStore) {
        self.store = store
    }
    
    func listNews(completion: @escaping NewsStoreListCompletionHandler) {
        store.listNews { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
