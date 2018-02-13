//
//  CreateWalletInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol CreateWalletBusinessLogic {
    var presenter: CreateWalletPresentationLogic? { get set }
    
    func createWallet()
}

class CreateWalletInteractor: CreateWalletBusinessLogic {
    var presenter: CreateWalletPresentationLogic?
    
    let localWalletWorker: WalletWorker!
    var remoteWalletWorker: WalletWorker!

    init() {
        localWalletWorker = WalletWorker(store: WalletDiskStore())
    }
    
    func createWallet() {
        remoteWalletWorker = WalletWorker(store: WalletRPC())

        presenter?.handleShowLoading()
        
        if let seed = localWalletWorker.generateSeed(), let keyPair = localWalletWorker.generateKeyPair(seed: seed) {
            remoteWalletWorker.addWallet(keyPair: keyPair, completion: { [weak self] result in
                switch result {
                case .success(let address):
                    self?.presenter?.handleShowCreated(mnemonic: "TODO", address: address)
                case .failure:
                    self?.presenter?.handleShowError(error: .couldNotCreateWallet)
                }
            })
        } else {
            presenter?.handleShowError(error: .couldNotCreateWallet)
        }
    }
    
}
