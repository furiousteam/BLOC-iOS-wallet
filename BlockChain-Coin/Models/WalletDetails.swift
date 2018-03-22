//
//  WalletDetails.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol WalletDetailsModel: Decodable {
    var availableBalance: Double { get }
    var lockedBalance: Double { get }
    var address: String { get }
    var transactions: [Transaction] { get }
}

class WalletDetails: WalletDetailsModel, Codable {
    let availableBalance: Double
    let lockedBalance: Double
    let address: String
    let transactions: [Transaction]
    
    enum CodingKeys: String, CodingKey {
        case availableBalance = "availableBalance"
        case lockedBalance = "lockedBalance"
        case address = "address"
        case transactions = "transactions"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(availableBalance, forKey: .availableBalance)
        try container.encode(lockedBalance, forKey: .lockedBalance)
        try container.encode(address, forKey: .address)
        try container.encode(transactions, forKey: .transactions)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.availableBalance = try values.decode(Double.self, forKey: .availableBalance)
        
        self.lockedBalance = try values.decode(Double.self, forKey: .lockedBalance)
        
        self.address = try values.decode(String.self, forKey: .address)
        
        self.transactions = try values.decode([Transaction].self, forKey: .transactions)
    }
    
}
