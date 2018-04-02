//  
//  ShowMiningStatsPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

protocol ShowMiningStatsPresentationLogic {
    func handleShowStats(poolStats: PoolStatsModel, addressStats: MiningAddressStatsModel)
    func handleShowLoading()
    func handleShowError(error: PoolStoreError)
}

class ShowMiningStatsPresenter: ShowMiningStatsPresentationLogic {
    weak var viewController: ShowMiningStatsDisplayLogic?
    
    func handleShowStats(poolStats: PoolStatsModel, addressStats: MiningAddressStatsModel) {
        let stats = ShowMiningStatsResponse(poolStats: poolStats, addressStats: addressStats)
        let viewModel = ShowMiningStatsViewModel(state: .loaded(stats))
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = ShowMiningStatsViewModel(state: .loading)
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: PoolStoreError) {
        let viewModel = ShowMiningStatsViewModel(state: .error(error.localizedDescription))
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
