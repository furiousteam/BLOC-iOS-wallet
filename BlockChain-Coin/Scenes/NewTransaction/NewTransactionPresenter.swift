//  
//  NewTransactionPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 21/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

protocol NewTransactionPresentationLogic {
    func handleFormIsValid(valid: Bool)
    func handleShowWallets(wallets: [WalletModel])
    func handleShowLoading()
    func handleShowError(error: WalletStoreError)
}

class NewTransactionPresenter: NewTransactionPresentationLogic {
    weak var viewController: NewTransactionDisplayLogic?
    
    func handleFormIsValid(valid: Bool) {
        let state: NewTransactionViewModel.State = valid ? .validForm : .invalidForm
        
        let viewModel = NewTransactionViewModel(state: state)
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
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
