//  
//  SetMiningWalletPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

protocol SetMiningWalletPresentationLogic {
    func handleShowWallets(wallets: [WalletModel])
    func handleShowLoading()
    func handleShowError(error: WalletStoreError)
}

class SetMiningWalletPresenter: SetMiningWalletPresentationLogic {
    weak var viewController: SetMiningWalletDisplayLogic?
    
    func handleShowWallets(wallets: [WalletModel]) {
        let sortedWallets = wallets.sorted(by: { a, b in return a.createdAt < b.createdAt })
        let viewModel = NewTransactionWalletsViewModel(state: .loaded(sortedWallets))
        viewController?.handleWalletsUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = NewTransactionWalletsViewModel(state: .loading)
        viewController?.handleWalletsUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: WalletStoreError) {
        let viewModel = NewTransactionWalletsViewModel(state: .error(error.localizedDescription))
        viewController?.handleWalletsUpdate(viewModel: viewModel)
    }
}
