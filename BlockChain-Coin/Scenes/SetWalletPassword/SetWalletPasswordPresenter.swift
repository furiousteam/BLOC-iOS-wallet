//  
//  SetWalletPasswordPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

protocol SetWalletPasswordPresentationLogic {
    func handleFormIsValid(valid: Bool)
    func handleWalletCreated(response: SetWalletPasswordResponse)
    func handleShowError(error: WalletStoreError)
    func handleShowLoading()
}

class SetWalletPasswordPresenter: SetWalletPasswordPresentationLogic {
    weak var viewController: SetWalletPasswordDisplayLogic?
    
    func handleFormIsValid(valid: Bool) {
        let state: SetWalletPasswordViewModel.State = valid ? .validForm : .invalidForm
        
        let viewModel = SetWalletPasswordViewModel(state: state)
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = SetWalletPasswordViewModel(state: .loading)
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: WalletStoreError) {
        let viewModel = SetWalletPasswordViewModel(state: .error(error.localizedDescription))
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleWalletCreated(response: SetWalletPasswordResponse) {
        let viewModel = SetWalletPasswordViewModel(state: .completed(response.address))
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
