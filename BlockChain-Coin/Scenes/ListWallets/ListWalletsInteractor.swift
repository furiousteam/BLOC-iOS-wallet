//
//  ListWalletsInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol ListWalletsBusinessLogic {
    var presenter: ListWalletsPresentationLogic? { get set }
    
    func fetchWallets()
}

class ListWalletsInteractor: ListWalletsBusinessLogic {
    var presenter: ListWalletsPresentationLogic?
    
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
}
