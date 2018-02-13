//
//  ListWalletsPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ListWalletsPresentationLogic {
    func handleShowWallets(wallets: [WalletModel])
    func handleShowLoading()
    func handleShowError(error: WalletStoreError)
}

class ListWalletsPresenter: ListWalletsPresentationLogic {
    weak var viewController: ListWalletsDisplayLogic?
    
    func handleShowWallets(wallets: [WalletModel]) {
        let viewModel = ListWalletsViewModel(state: .loaded(wallets))
        viewController?.handleWalletsUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = ListWalletsViewModel(state: .loading)
        viewController?.handleWalletsUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: WalletStoreError) {
        let viewModel = ListWalletsViewModel(state: .error(error.localizedDescription))
        viewController?.handleWalletsUpdate(viewModel: viewModel)
    }
}
