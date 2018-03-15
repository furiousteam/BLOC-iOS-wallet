//  
//  SetWalletPasswordInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol SetWalletPasswordBusinessLogic {
    var presenter: SetWalletPasswordPresentationLogic? { get set }
    
    func validateForm(request: SetWalletPasswordRequest)
    func setPassword(request: SetWalletPasswordRequest)
}

class SetWalletPasswordInteractor: SetWalletPasswordBusinessLogic {
    var presenter: SetWalletPasswordPresentationLogic?
    
    let localWalletWorker: WalletWorker!
    var remoteWalletWorker: WalletWorker!

    init() {
        localWalletWorker = WalletWorker(store: WalletDiskStore())
        remoteWalletWorker = WalletWorker(store: WalletAPI())
    }
    
    func setPassword(request: SetWalletPasswordRequest) {
        presenter?.handleShowLoading()
        
        if let seed = localWalletWorker.generateSeed(), let keyPair = localWalletWorker.generateKeyPair(seed: seed) {
            let uuid = UUID()
            
            remoteWalletWorker.addWallet(keyPair: keyPair, uuid: uuid, secretKey: nil, password: nil, address: nil, completion: { [weak self] result in
                switch result {
                case .success(let address):
                    self?.localWalletWorker.addWallet(keyPair: keyPair, uuid: uuid, secretKey: nil, password: request.form.password, address: address, completion: { localResult in
                        switch localResult {
                        case .success:
                            log.info("New wallet created: \(address)")
                            
                            self?.presenter?.handleWalletCreated(response: SetWalletPasswordResponse(address: address))
                        case .failure:
                            self?.presenter?.handleShowError(error: .couldNotCreateWallet)
                        }
                    })
                case .failure:
                    self?.presenter?.handleShowError(error: .couldNotCreateWallet)
                }
            })
        } else {
            presenter?.handleShowError(error: .couldNotCreateWallet)
        }
    }
    
    func validateForm(request: SetWalletPasswordRequest) {
        presenter?.handleFormIsValid(valid: request.form.isValid)
    }
}
