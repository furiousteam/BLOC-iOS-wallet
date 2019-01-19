//  
//  ImportWalletQRCodePresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 17/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

protocol ImportWalletQRCodePresentationLogic {
    func handleFormIsValid(valid: Bool)
    func handleWalletCreated(response: ImportWalletQRCodeResponse)
    func handleShowError(error: WalletStoreError)
    func handleShowLoading()
}

class ImportWalletQRCodePresenter: ImportWalletQRCodePresentationLogic {
    weak var viewController: ImportWalletQRCodeDisplayLogic?
    
    func handleFormIsValid(valid: Bool) {
        let state: ImportWalletQRCodeViewModel.State = valid ? .validForm : .invalidForm
        
        let viewModel = ImportWalletQRCodeViewModel(state: state)
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = ImportWalletQRCodeViewModel(state: .loading)
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: WalletStoreError) {
        let viewModel = ImportWalletQRCodeViewModel(state: .error(error.localizedDescription))
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handleWalletCreated(response: ImportWalletQRCodeResponse) {
        let viewModel = ImportWalletQRCodeViewModel(state: .completed(response.wallet))
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
