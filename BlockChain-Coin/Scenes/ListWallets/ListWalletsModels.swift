//
//  ListWalletsModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

struct ListWalletsViewModel {
    enum State {
        case loading
        case loaded([WalletModel])
        case error(String)
    }
    
    let state: State
    let wallets: [WalletModel]
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let wallets):
            self.wallets = wallets
        default:
            self.wallets = []
        }
    }
}
