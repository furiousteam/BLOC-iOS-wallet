//
//  ShowWalletPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ShowWalletPresentationLogic {
    func handleShowBalances(balances: [BalanceModel])
    func handleShowBalancesLoading()
    func handleShowBalancesError(error: WalletStoreError)
}

class ShowWalletPresenter: ShowWalletPresentationLogic {
    weak var viewController: ShowWalletDisplayLogic?
    
    // Balances
    
    func handleShowBalances(balances: [BalanceModel]) {
        let viewModel = ShowWalletBalancesViewModel(state: .loaded(balances))
        viewController?.handleBalancesUpdate(viewModel: viewModel)
    }
    
    func handleShowBalancesLoading() {
        let viewModel = ShowWalletBalancesViewModel(state: .loading)
        viewController?.handleBalancesUpdate(viewModel: viewModel)
    }
    
    func handleShowBalancesError(error: WalletStoreError) {
        let viewModel = ShowWalletBalancesViewModel(state: .error(error.localizedDescription))
        viewController?.handleBalancesUpdate(viewModel: viewModel)
    }
}
