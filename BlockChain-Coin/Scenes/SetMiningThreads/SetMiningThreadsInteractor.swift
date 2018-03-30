//  
//  SetMiningThreadsInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol SetMiningThreadsBusinessLogic {
    var presenter: SetMiningThreadsPresentationLogic? { get set }

    func saveSelectedThreads(threads: UInt)
}

class SetMiningThreadsInteractor: SetMiningThreadsBusinessLogic {
    var presenter: SetMiningThreadsPresentationLogic?
    
    let minerWorker = MinerWorker(store: CryptonightMiner())

    func saveSelectedThreads(threads: UInt) {
        minerWorker.fetchSettings { [weak self] result in
            switch result {
            case .success(let settings):
                let s = MiningSettings(threads: threads, wallet: settings.wallet, pool: settings.pool)
                
                self?.minerWorker.saveSettings(settings: s)
            case .failure(let error):
                log.error("Could not save settings: \(error)")
                break
            }
        }
    }
}
