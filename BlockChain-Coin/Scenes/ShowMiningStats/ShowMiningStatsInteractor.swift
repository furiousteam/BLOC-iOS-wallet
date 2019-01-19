//  
//  ShowMiningStatsInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol ShowMiningStatsBusinessLogic {
    var presenter: ShowMiningStatsPresentationLogic? { get set }

    func fetchStats(settings: MiningSettingsModel)
}

class ShowMiningStatsInteractor: ShowMiningStatsBusinessLogic {
    var presenter: ShowMiningStatsPresentationLogic?
    
    let poolAPIWorker = PoolWorker(store: PoolAPI())

    func fetchStats(settings: MiningSettingsModel) {
        presenter?.handleShowLoading()
        
        poolAPIWorker.stats(pool: settings.pool) { [weak self] result in
            switch result {
            case .success(let pool):
                if let stats = pool.stats {
                    self?.poolAPIWorker.addressStats(pool: settings.pool, address: settings.wallet.address) { [weak self] result in
                        switch result {
                        case .success(let addressStats):
                            self?.presenter?.handleShowStats(poolStats: stats, addressStats: addressStats)
                        case .failure(let error):
                            log.error(error)
                            self?.presenter?.handleShowError(error: error)
                        }
                    }
                } else {
                    self?.presenter?.handleShowError(error: .unknown)
                }
            case .failure(let error):
                log.error(error)
                self?.presenter?.handleShowError(error: error)
            }
        }
        

    }
}
