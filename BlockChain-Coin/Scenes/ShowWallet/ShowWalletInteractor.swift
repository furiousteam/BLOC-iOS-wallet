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
    
    let remoteWalletWorker = WalletWorker(store: WalletAPI())
    let localWalletWorker = WalletWorker(store: WalletDiskStore())

    func fetchDetails(wallet: WalletModel, password: String) {
        presenter?.handleShowDetailsLoading()
        
        remoteWalletWorker.getBalanceAndTransactions(wallet: wallet, password: password) { [weak self] result in
            switch result {
            case .success(let details):
                let w = Wallet(uuid: wallet.uuid, keyPair: wallet.keyPair, address: wallet.address, password: wallet.password ?? "", name: wallet.name, details: details, createdAt: wallet.createdAt)
                
                self?.localWalletWorker.getBalanceAndTransactions(wallet: w, password: password, completion: { [weak self] result in
                    switch result {
                    case .success(let details):
                        self?.presenter?.handleShowDetails(details: details)
                    case .failure(let error):
                        self?.presenter?.handleShowDetailsError(error: error)
                    }
                })
            case .failure(let error):
                self?.presenter?.handleShowDetailsError(error: error)
            }
        }
    }
}
