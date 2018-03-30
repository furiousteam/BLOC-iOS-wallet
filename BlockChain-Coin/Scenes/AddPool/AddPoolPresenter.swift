//  
//  AddPoolPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

protocol AddPoolPresentationLogic {
    func handleFormIsValid(valid: Bool)
    func handlePoolAdded()
}

class AddPoolPresenter: AddPoolPresentationLogic {
    weak var viewController: AddPoolDisplayLogic?
    
    func handleFormIsValid(valid: Bool) {
        let state: AddPoolViewModel.State = valid ? .validForm : .invalidForm
        
        let viewModel = AddPoolViewModel(state: state)
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
    
    func handlePoolAdded() {
        let viewModel = AddPoolViewModel(state: .completed)
        
        viewController?.handleUpdate(viewModel: viewModel)
    }
}
