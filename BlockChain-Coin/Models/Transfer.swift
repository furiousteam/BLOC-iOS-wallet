//
//  Transfer.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol TransferModel {
    var address: String { get }
    var amount: Double { get }
}

struct Transfer: TransferModel, Codable {
    let address: String
    let amount: Double
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case amount = "amount"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(address, forKey: .address)
        try container.encode(amount, forKey: .amount)
    }
    
    init(address: String, amount: Double) {
        self.address = address
        self.amount = amount
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.address = try values.decode(String.self, forKey: .address)
        
        let amountInt = try values.decode(Double.self, forKey: .amount)
        self.amount = amountInt / Constants.walletCurrencyDivider
    }
}
