//  
//  ListPoolsPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

protocol ListPoolsPresentationLogic {
    func handleShowPools(pools: [MiningPoolModel])
    func handleShowLoading()
    func handleShowError(error: PoolStoreError)
}

class ListPoolsPresenter: ListPoolsPresentationLogic {
    weak var viewController: ListPoolsDisplayLogic?
    
    func handleShowPools(pools: [MiningPoolModel]) {
        let viewModel = ListPoolsViewModel(state: .loaded(pools))
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = ListPoolsViewModel(state: .loading)
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: PoolStoreError) {
        let viewModel = ListPoolsViewModel(state: .error(error.localizedDescription))
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
