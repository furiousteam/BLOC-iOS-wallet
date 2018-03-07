//
//  TransactionDestination.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol TransactionDestinationModel {
    var address: AddressModel { get }
    var amount: UInt64 { get }
}

struct TransactionDestination: TransactionDestinationModel {
    let address: AddressModel
    let amount: UInt64
}
