//  
//  ExportWalletKeysModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct ExportWalletKeysViewModel {
    enum State {
        case loading
        case loaded(String)
        case error(String)
    }
    
    let state: State
    let keys: String?
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let keys):
            self.keys = keys
        default:
            self.keys = nil
        }
    }
}

struct ExportWalletKeysRequest {
    let wallet: WalletModel
}
