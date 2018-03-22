//  
//  ImportWalletQRCodeInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 17/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol ImportWalletQRCodeBusinessLogic {
    var presenter: ImportWalletQRCodePresentationLogic? { get set }

    func validateForm(request: ImportWalletQRCodeRequest)
    func importWallet(request: ImportWalletQRCodeRequest)
}

class ImportWalletQRCodeInteractor: ImportWalletQRCodeBusinessLogic {
    var presenter: ImportWalletQRCodePresentationLogic?
    
    let localWalletWorker: WalletWorker!
    var remoteWalletWorker: WalletWorker!
    
    init() {
        localWalletWorker = WalletWorker(store: WalletDiskStore())
        remoteWalletWorker = WalletWorker(store: WalletAPI())
    }

    func validateForm(request: ImportWalletQRCodeRequest) {
        presenter?.handleFormIsValid(valid: request.form.isValid)
    }
    
    func importWallet(request: ImportWalletQRCodeRequest) {
        presenter?.handleShowLoading()
        
        if let seed = localWalletWorker.generateSeed(), let keyPair = localWalletWorker.generateKeyPair(seed: seed) {
            let uuid = UUID()
            
            remoteWalletWorker.addWallet(keyPair: keyPair, uuid: uuid, secretKey: request.form.spendPrivateKey, password: nil, address: nil, details: nil, completion: { [weak self] result in
                switch result {
                case .success(let address):
                    let wallet = Wallet(uuid: uuid, keyPair: keyPair, address: address, password: request.form.password ?? "", details: nil, createdAt: Date())

                    self?.remoteWalletWorker.getBalanceAndTransactions(wallet: wallet, password: wallet.password ?? "", completion: { detailsResult in
                        switch detailsResult {
                        case .success(let details):
                            self?.localWalletWorker.addWallet(keyPair: keyPair, uuid: uuid, secretKey: request.form.spendPrivateKey, password: request.form.password, address: address, details: details, completion: { localResult in
                                switch localResult {
                                case .success:
                                    log.info("New wallet created: \(address)")
                                    
                                    let wallet = Wallet(uuid: uuid, keyPair: keyPair, address: address, password: request.form.password, details: details, createdAt: Date())
                                    self?.presenter?.handleWalletCreated(response: ImportWalletQRCodeResponse(wallet: wallet))
                                case .failure:
                                    self?.presenter?.handleShowError(error: .couldNotCreateWallet)
                                }
                            })
                        case .failure:
                            self?.presenter?.handleShowError(error: .couldNotCreateWallet)
                        }
                    })
                case .failure(let error):
                    self?.presenter?.handleShowError(error: error)
                }
            })
        } else {
            presenter?.handleShowError(error: .couldNotCreateWallet)
        }
    }
}
