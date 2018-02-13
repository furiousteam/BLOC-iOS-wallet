//
//  CreateWalletPresenter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol CreateWalletPresentationLogic {
    func handleShowCreated(mnemonic: String, address: String)
    func handleShowLoading()
    func handleShowError(error: WalletStoreError)
}

class CreateWalletPresenter: CreateWalletPresentationLogic {
    weak var viewController: CreateWalletDisplayLogic?
    
    func handleShowCreated(mnemonic: String, address: String) {
        let viewModel = CreateWalletViewModel(state: .created(mnemonic: mnemonic, address: address))
        viewController?.handleWalletCreateUpdate(viewModel: viewModel)
    }
    
    func handleShowLoading() {
        let viewModel = CreateWalletViewModel(state: .creating)
        viewController?.handleWalletCreateUpdate(viewModel: viewModel)
    }
    
    func handleShowError(error: WalletStoreError) {
        let viewModel = CreateWalletViewModel(state: .error(error.localizedDescription))
        viewController?.handleWalletCreateUpdate(viewModel: viewModel)
    }
}
