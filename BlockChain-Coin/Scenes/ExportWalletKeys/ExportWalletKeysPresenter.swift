//  
//  ExportWalletKeysPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

protocol ExportWalletKeysPresentationLogic {
    func handleShowKeys(keys: String)
    func handleShowLoading()
    func handleShowError(error: WalletStoreError)
}

class ExportWalletKeysPresenter: ExportWalletKeysPresentationLogic {
    weak var viewController: ExportWalletKeysDisplayLogic?
    
    func handleShowKeys(keys: String) {
        let viewModel = ExportWalletKeysViewModel(state: .loaded(keys))
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = ExportWalletKeysViewModel(state: .loading)
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: WalletStoreError) {
        let viewModel = ExportWalletKeysViewModel(state: .error(error.localizedDescription))
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
