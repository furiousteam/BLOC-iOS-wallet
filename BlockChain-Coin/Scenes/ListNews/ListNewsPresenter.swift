//  
//  ListNewsPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

protocol ListNewsPresentationLogic {
    func handleLoading()
    func handleShowNews(news: [NewsModel])
    func handleShowError(error: NewsStoreError)
}

class ListNewsPresenter: ListNewsPresentationLogic {
    weak var viewController: ListNewsDisplayLogic?
    
    func handleLoading() {
        let viewModel = ListNewsViewModel(state: .loading)
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowNews(news: [NewsModel]) {
        let viewModel = ListNewsViewModel(state: .loaded(news))
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: NewsStoreError) {
        let viewModel = ListNewsViewModel(state: .error(error.localizedDescription))
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
