//  
//  ExportWalletKeysInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol ExportWalletKeysBusinessLogic {
    var presenter: ExportWalletKeysPresentationLogic? { get set }

    func getKeys(request: ExportWalletKeysRequest)
}

class ExportWalletKeysInteractor: ExportWalletKeysBusinessLogic {
    var presenter: ExportWalletKeysPresentationLogic?
    
    let walletWorker = WalletWorker(store: WalletAPI())

    func getKeys(request: ExportWalletKeysRequest) {
        presenter?.handleShowLoading()
        
        walletWorker.getKeys(wallet: request.wallet, password: request.wallet.password ?? "") { [weak self] result in
            switch result {
            case .success(let keys):
                let keysString = [ keys.spendPublicKey, keys.viewPublicKey, keys.spendPrivateKey, keys.viewPrivateKey ].joined()
                self?.presenter?.handleShowKeys(keys: keysString)
            case .failure(let error):
                self?.presenter?.handleShowError(error: error)
            }
        }
    }
}
