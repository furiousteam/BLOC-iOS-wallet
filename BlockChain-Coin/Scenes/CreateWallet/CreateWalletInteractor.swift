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
        remoteWalletWorker = WalletWorker(store: WalletAPI())
    }
    
    func createWallet() {
        presenter?.handleShowLoading()
        
        if let seed = localWalletWorker.generateSeed(), let keyPair = localWalletWorker.generateKeyPair(seed: seed) {
            let uuid = UUID()
            
            remoteWalletWorker.addWallet(keyPair: keyPair, uuid: uuid, secretKey: nil, address: nil, completion: { [weak self] result in
                switch result {
                case .success(let address):
                    self?.localWalletWorker.addWallet(keyPair: keyPair, uuid: uuid, secretKey: nil, address: address, completion: { localResult in
                        switch localResult {
                        case .success:
                            print("New wallet created: \(address)")
                            self?.presenter?.handleShowCreated(mnemonic: "TODO", address: address)
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
    
}
