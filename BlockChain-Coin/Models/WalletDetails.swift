//
//  WalletDetails.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol WalletDetailsModel: Decodable {
    var availableBalance: UInt64 { get }
    var lockedBalance: UInt64 { get }
    var address: String { get }
    var transactions: [TransactionModel] { get }
}

struct WalletDetails: WalletDetailsModel {
    let availableBalance: UInt64
    let lockedBalance: UInt64
    let address: String
    let transactions: [TransactionModel]
    
    enum CodingKeys: String, CodingKey {
        case availableBalance = "availableBalance"
        case lockedBalance = "lockedBalance"
        case address = "address"
        case transactions = "transactions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.availableBalance = try values.decode(UInt64.self, forKey: .availableBalance)
        
        self.lockedBalance = try values.decode(UInt64.self, forKey: .lockedBalance)
        
        self.address = try values.decode(String.self, forKey: .address)
        
        self.transactions = try values.decode([Transaction].self, forKey: .transactions)
    }
}
