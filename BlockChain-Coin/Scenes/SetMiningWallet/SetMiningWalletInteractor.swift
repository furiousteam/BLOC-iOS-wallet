//  
//  SetMiningWalletInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol SetMiningWalletBusinessLogic {
    var presenter: SetMiningWalletPresentationLogic? { get set }

    func fetchWallets()
    func saveSelectedWallet(wallet: Wallet)
}

class SetMiningWalletInteractor: SetMiningWalletBusinessLogic {
    var presenter: SetMiningWalletPresentationLogic?
    
    let walletWorker = WalletWorker(store: WalletDiskStore())
    let minerWorker = MinerWorker(store: CryptonightMiner())

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
    
    func saveSelectedWallet(wallet: Wallet) {
        minerWorker.fetchSettings { [weak self] result in
            switch result {
            case .success(let settings):
                let s = MiningSettings(threads: settings.threads, wallet: wallet, pool: settings.pool)
                
                self?.minerWorker.saveSettings(settings: s)
            case .failure(let error):
                log.error("Could not save settings: \(error)")
                break
            }
        }
    }
}
