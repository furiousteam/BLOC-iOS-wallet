//
//  ShowWalletModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct ShowWalletDetailsViewModel {
    enum State {
        case loading
        case loaded(WalletDetails)
        case error(String)
    }
    
    let state: State
    let details: WalletDetails?
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let details):
            self.details = details
        default:
            self.details = nil
        }
    }
}
