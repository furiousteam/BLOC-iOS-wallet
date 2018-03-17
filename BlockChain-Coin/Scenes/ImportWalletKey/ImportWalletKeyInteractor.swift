//  
//  ImportWalletKeyInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol ImportWalletKeyBusinessLogic {
    var presenter: ImportWalletKeyPresentationLogic? { get set }

    func validateForm(request: ImportWalletKeyRequest)
    func importWallet(request: ImportWalletKeyRequest)
}

class ImportWalletKeyInteractor: ImportWalletKeyBusinessLogic {
    var presenter: ImportWalletKeyPresentationLogic?
    
    let localWalletWorker: WalletWorker!
    var remoteWalletWorker: WalletWorker!

    init() {
        localWalletWorker = WalletWorker(store: WalletDiskStore())
        remoteWalletWorker = WalletWorker(store: WalletAPI())
    }

    func validateForm(request: ImportWalletKeyRequest) {
        presenter?.handleFormIsValid(valid: request.form.isValid)
    }
    
    func importWallet(request: ImportWalletKeyRequest) {
        presenter?.handleShowLoading()

        if let seed = localWalletWorker.generateSeed(), let keyPair = localWalletWorker.generateKeyPair(seed: seed) {
            let uuid = UUID()
            
            remoteWalletWorker.addWallet(keyPair: keyPair, uuid: uuid, secretKey: request.form.spendPrivateKey, password: nil, address: nil, completion: { [weak self] result in
                switch result {
                case .success(let address):
                    log.info("New wallet created: \(address)")
                    
                    let wallet = Wallet(uuid: uuid, keyPair: keyPair, address: address, password: "", createdAt: Date())
                    self?.presenter?.handleWalletCreated(response: ImportWalletKeyResponse(wallet: wallet))
                case .failure(let error):
                    self?.presenter?.handleShowError(error: error)
                }
            })
        }
    }
}
