//  
//  ListTransactionsModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct ListTransactionItemViewModel {
    let name: String
    let sourceAddress: String
    let transaction: TransactionModel
}

struct ListTransactionsViewModel {
    enum State {
        case loading
        case loaded([ListTransactionItemViewModel])
        case error(String)
    }
    
    let state: State
    let transactions: [ListTransactionItemViewModel]
    
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
