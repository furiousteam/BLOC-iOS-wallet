//  
//  ConfirmTransactionPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

protocol ConfirmTransactionPresentationLogic {
    func handleShowTransactionHash(transactionHash: String)
    func handleShowLoading()
    func handleShowError(error: WalletStoreError)
}

class ConfirmTransactionPresenter: ConfirmTransactionPresentationLogic {
    weak var viewController: ConfirmTransactionDisplayLogic?
    
    func handleShowTransactionHash(transactionHash: String) {
        let viewModel = ConfirmTransactionViewModel(state: .loaded(transactionHash))
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = ConfirmTransactionViewModel(state: .loading)
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: WalletStoreError) {
        let viewModel = ConfirmTransactionViewModel(state: .error(error.localizedDescription))
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
