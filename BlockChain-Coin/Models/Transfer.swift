//
//  Transfer.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol TransferModel {
    var address: String { get }
    var amount: Double { get }
}

struct Transfer: TransferModel, Decodable {
    let address: String
    let amount: Double
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case amount = "amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.address = try values.decode(String.self, forKey: .address)
        
        let amountInt = try values.decode(Int64.self, forKey: .amount)
        self.amount = Double(amountInt) / Constants.walletCurrencyDivider
    }
}
