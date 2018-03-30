//  
//  ListPoolsInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol ListPoolsBusinessLogic {
    var presenter: ListPoolsPresentationLogic? { get set }

    func fetchPools()
    func addPool(pool: MiningPool)
    func saveSelectedPool(pool: MiningPool)
}

class ListPoolsInteractor: ListPoolsBusinessLogic {
    var presenter: ListPoolsPresentationLogic?
    
    let poolWorker = PoolWorker(store: PoolAPI())
    let minerWorker = MinerWorker(store: CryptonightMiner())

    func fetchPools() {
        presenter?.handleShowLoading()
        
        poolWorker.listPools { [weak self] result in
            switch result {
            case .success(let poolsWithoutStats):                
                self?.poolWorker.stats(pools: poolsWithoutStats, completion: { result in
                    switch result {
                    case .success(let pools):
                        self?.presenter?.handleShowPools(pools: pools)
                    case .failure(let error):
                        self?.presenter?.handleShowError(error: error)
                    }
                })
            case .failure(let error):
                self?.presenter?.handleShowError(error: error)
            }
        }
    }
    
    func addPool(pool: MiningPool) {
        self.poolWorker.addPool(pool: pool)
    }
    
    func saveSelectedPool(pool: MiningPool) {
        minerWorker.fetchSettings { [weak self] result in
            switch result {
            case .success(let settings):
                let s = MiningSettings(threads: settings.threads, wallet: settings.wallet, pool: pool)
                
                self?.minerWorker.saveSettings(settings: s)
            case .failure(let error):
                log.error("Could not save settings: \(error)")
                break
            }
        }
    }

}
