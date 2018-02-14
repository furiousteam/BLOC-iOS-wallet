//
//  WalletRPCGetBalanceResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol WalletRPCGetBalanceResponseModel {
    var availableBalance: Double { get }
    var lockedBalance: Double { get }
}

struct WalletRPCGetBalanceResponse: WalletRPCGetBalanceResponseModel {
    let availableBalance: Double
    let lockedBalance: Double
}
