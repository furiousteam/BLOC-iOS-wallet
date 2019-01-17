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
        case loaded(details: WalletDetails, priceHistory: [PriceHistoryItemModel]?)
        case error(String)
    }
    
    let state: State
    let details: WalletDetails?
    let priceHistory: [PriceHistoryItemModel]?
    
    var blocValue: Double? {
        return priceHistory?.last?.value
    }
    
    var lastDayChange: Double? {
        guard let priceHistory = priceHistory, let lastPrice = priceHistory.last else { return nil }
        
        let yesterdayTimestamp = (lastPrice.timestamp - 86_400)
        
        let yesterday = priceHistory.min { (a, b) -> Bool in
            return abs(TimeInterval(a.timestamp) - yesterdayTimestamp) < abs(TimeInterval(b.timestamp) - yesterdayTimestamp)
        }
        
        guard let yesterdayValue = yesterday?.value else { return nil }
        
        return ((lastPrice.value / yesterdayValue) - 1) * 100.0
    }
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let details, let priceHistory):
            self.details = details
            self.priceHistory = priceHistory
        default:
            self.details = nil
            self.priceHistory = nil
        }
    }
}
