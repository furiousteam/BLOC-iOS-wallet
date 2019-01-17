//
//  CoinGeckoPriceHistoryResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/12/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol CoinGeckoPriceHistoryResponseModel {
    var prices: [PriceHistoryItemModel] { get }
}

protocol PriceHistoryItemModel {
    var timestamp: TimeInterval { get }
    var value: Double { get }
}

class PriceHistoryItem: PriceHistoryItemModel, Decodable, CustomStringConvertible {
    let timestamp: TimeInterval
    let value: Double
    
    init(timestamp: TimeInterval, value: Double) {
        self.timestamp = timestamp
        self.value = value
    }
    
    var description: String {
        let dateString = Date(timeIntervalSince1970: timestamp).shortDate()
        
        return "\(dateString) - \(value)"
    }
}

class CoinGeckoPriceHistoryResponse: CoinGeckoPriceHistoryResponseModel, Decodable {
    enum CodingKeys: String, CodingKey {
        case prices = "prices"
    }
    
    let prices: [PriceHistoryItemModel]
    
    init(prices: [PriceHistoryItemModel]) {
        self.prices = prices
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let pricesTuples = try values.decode([[Double]].self, forKey: .prices)
        
        self.prices = pricesTuples.compactMap({ tuple -> PriceHistoryItemModel? in
            guard tuple.count == 2 else { return nil }
            
            return PriceHistoryItem(timestamp: tuple[0] / 1000, value: tuple[1])
        }).sorted(by: { (a, b) -> Bool in
            return a.timestamp < b.timestamp
        })
    }
    
}
