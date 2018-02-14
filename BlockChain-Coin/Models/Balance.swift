//
//  Balance.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

enum BalanceType {
    case available
    case locked
    
    var name: String {
        switch self {
        case .available:
            return "Available balance"
        case .locked:
            return "Locked balance"
        }
    }
}

protocol BalanceModel {
    var value: Double { get }
    var balanceType: BalanceType { get }
}

struct Balance: BalanceModel {
    let value: Double
    let balanceType: BalanceType
}
