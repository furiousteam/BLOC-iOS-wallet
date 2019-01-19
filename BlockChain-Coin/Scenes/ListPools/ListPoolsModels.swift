//  
//  ListPoolsModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

struct ListPoolsViewModel {
    
    enum State {
        case loading
        case loaded([MiningPoolModel])
        case error(String)
    }
    
    let state: State
    let pools: [MiningPoolModel]
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let pools):
            self.pools = pools
        default:
            self.pools = []
        }
    }
}

struct ListPoolsRequest {
    var pools: [MiningPoolModel]
}
