//
//  WalletRPCGetBalanceResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol WalletRPCGetBalanceResponseModel {
    var availableBalance: Double { get }
    var lockedBalance: Double { get }
}

struct WalletRPCGetBalanceResponse: WalletRPCGetBalanceResponseModel, Decodable {
    let availableBalance: Double
    let lockedBalance: Double
    
    enum CodingKeys: String, CodingKey {
        case availableBalance = "availableBalance"
        case lockedBalance = "lockedAmount"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let availableBalanceInt = try values.decode(UInt64.self, forKey: .availableBalance)
        let lockedBalanceInt = try values.decode(UInt64.self, forKey: .lockedBalance)
        
        self.availableBalance = Double(availableBalanceInt) / Constants.walletCurrencyDivider
        self.lockedBalance = Double(lockedBalanceInt) / Constants.walletCurrencyDivider
    }
}
