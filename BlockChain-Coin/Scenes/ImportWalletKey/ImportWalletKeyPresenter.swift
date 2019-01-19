//  
//  ImportWalletKeyPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

protocol ImportWalletKeyPresentationLogic {
    func handleFormIsValid(valid: Bool)
    func handleWalletCreated(response: ImportWalletKeyResponse)
    func handleShowError(error: WalletStoreError)
    func handleShowLoading()
}

class ImportWalletKeyPresenter: ImportWalletKeyPresentationLogic {
    weak var viewController: ImportWalletKeyDisplayLogic?
    
    func handleFormIsValid(valid: Bool) {
        let state: ImportWalletKeyViewModel.State = valid ? .validForm : .invalidForm
        
        let viewModel = ImportWalletKeyViewModel(state: state)
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = ImportWalletKeyViewModel(state: .loading)
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: WalletStoreError) {
        let viewModel = ImportWalletKeyViewModel(state: .error(error.localizedDescription))
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleWalletCreated(response: ImportWalletKeyResponse) {
        let viewModel = ImportWalletKeyViewModel(state: .completed(response.wallet))
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
