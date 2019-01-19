//  
//  ListNewsInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol ListNewsBusinessLogic {
    var presenter: ListNewsPresentationLogic? { get set }

    func fetchNews()
}

class ListNewsInteractor: ListNewsBusinessLogic {
    var presenter: ListNewsPresentationLogic?
    let newsWorker = NewsWorker(store: NewsRSSFeed())
    
    func fetchNews() {
        presenter?.handleLoading()

        newsWorker.listNews { [weak self] result in
            switch result {
            case .success(let news):
                self?.presenter?.handleShowNews(news: news)
            case .failure(let error):
                self?.presenter?.handleShowError(error: error)
            }
        }
    }
}
