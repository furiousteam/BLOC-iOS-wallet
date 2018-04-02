//  
//  ShowMiningStatsModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct ShowMiningStatsViewModel {
    
    enum State {
        case loading
        case loaded(ShowMiningStatsResponse)
        case error(String)
    }
    
    let state: State
    let stats: ShowMiningStatsResponse?
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let stats):
            self.stats = stats
        default:
            self.stats = nil
        }
    }
}

struct ShowMiningStatsResponse {
    let poolStats: PoolStatsModel
    let addressStats: MiningAddressStatsModel
}
