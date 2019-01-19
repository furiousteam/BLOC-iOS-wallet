//
//  ShowWalletPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ShowWalletPresentationLogic {
    func handleShowDetails(details: WalletDetails, priceHistory: [PriceHistoryItemModel]?)
    func handleShowDetailsLoading()
    func handleShowDetailsError(error: WalletStoreError)
}

class ShowWalletPresenter: ShowWalletPresentationLogic {    
    weak var viewController: ShowWalletDisplayLogic?
    
    // Balances
    
    func handleShowDetails(details: WalletDetails, priceHistory: [PriceHistoryItemModel]?) {
        let viewModel = ShowWalletDetailsViewModel(state: .loaded(details: details, priceHistory: priceHistory))
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowDetailsLoading() {
        let viewModel = ShowWalletDetailsViewModel(state: .loading)
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowDetailsError(error: WalletStoreError) {
        let viewModel = ShowWalletDetailsViewModel(state: .error(error.localizedDescription))
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
