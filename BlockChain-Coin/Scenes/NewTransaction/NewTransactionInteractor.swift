//  
//  NewTransactionInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 21/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol NewTransactionBusinessLogic {
    var presenter: NewTransactionPresentationLogic? { get set }

    func fetchWallets()
    func validateForm(request: NewTransactionRequest)
}

class NewTransactionInteractor: NewTransactionBusinessLogic {
    var presenter: NewTransactionPresentationLogic?
    
    let walletWorker: WalletWorker
    
    init() {
        switch AppController.environment {
        case .development, .production:
            walletWorker = WalletWorker(store: WalletDiskStore())
        case .mock:
            walletWorker = WalletWorker(store: WalletMemStore())
        }
    }

    func fetchWallets() {
        presenter?.handleShowLoading()
        
        walletWorker.listWallets { [weak self] result in
            switch result {
            case .success(let wallets):
                self?.presenter?.handleShowWallets(wallets: wallets)
            case .failure(let error):
                self?.presenter?.handleShowError(error: error)
            }
        }
    }
    
    func validateForm(request: NewTransactionRequest) {
        presenter?.handleFormIsValid(valid: request.form.isValid)
    }
}
