//  
//  ListTransactionsInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol ListTransactionsBusinessLogic {
    var presenter: ListTransactionsPresentationLogic? { get set }

    func fetchAllTransactions()
    func fetchTransactions(forWallets wallets: [WalletModel])
}

class ListTransactionsInteractor: ListTransactionsBusinessLogic {
    var presenter: ListTransactionsPresentationLogic?
    
    let localWalletWorker = WalletWorker(store: WalletDiskStore())
    let remoteWalletWorker = WalletWorker(store: WalletAPI())

    func fetchAllTransactions() {
        presenter?.handleShowLoading()
        
        localWalletWorker.listWallets { [weak self] result in
            switch result {
            case .success(let wallets):
                self?.remoteWalletWorker.getAllWalletDetails(wallets: wallets) { [weak self] result in
                    switch result {
                    case .success(let walletsWithDetails):
                        self?.presenter?.handleShowTransactions(wallets: walletsWithDetails)
                    case .failure(let error):
                        self?.presenter?.handleShowError(error: error)
                    }
                }
            case .failure(let error):
                self?.presenter?.handleShowError(error: error)
            }
        }
    }
    
    func fetchTransactions(forWallets wallets: [WalletModel]) {
        presenter?.handleShowLoading()

        self.remoteWalletWorker.getAllWalletDetails(wallets: wallets) { [weak self] result in
            switch result {
            case .success(let walletsWithDetails):
                self?.presenter?.handleShowTransactions(wallets: walletsWithDetails)
            case .failure(let error):
                self?.presenter?.handleShowError(error: error)
            }
        }
    }
}
