//
//  ShowWalletInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol ShowWalletBusinessLogic {
    var presenter: ShowWalletPresentationLogic? { get set }
    
    func fetchDetails(wallet: WalletModel, password: String)
}

class ShowWalletInteractor: ShowWalletBusinessLogic {
    var presenter: ShowWalletPresentationLogic?
    
    let walletWorker = WalletWorker(store: WalletAPI())
    
    func fetchDetails(wallet: WalletModel, password: String) {
        presenter?.handleShowDetailsLoading()
        
        walletWorker.getBalanceAndTransactions(wallet: wallet, password: password) { [weak self] result in
            switch result {
            case .success(let details):
                self?.presenter?.handleShowDetails(details: details)
            case .failure(let error):
                self?.presenter?.handleShowDetailsError(error: error)
            }
        }
    }
}
