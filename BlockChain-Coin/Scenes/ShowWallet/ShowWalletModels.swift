//
//  ShowWalletModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct ShowWalletBalancesViewModel {
    enum State {
        case loading
        case loaded([BalanceModel])
        case error(String)
    }
    
    let state: State
    let balances: [BalanceModel]
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let wallets):
            self.balances = wallets
        default:
            self.balances = []
        }
    }
}

struct ShowWalletTransactionsViewModel {
    enum State {
        case loading
        case loaded([TransactionModel])
        case error(String)
    }
    
    let state: State
    let transactions: [TransactionModel]
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let transactions):
            self.transactions = transactions
        default:
            self.transactions = []
        }
    }
}
