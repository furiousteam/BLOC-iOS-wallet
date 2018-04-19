//
//  Constants.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct Constants {
    static let walletCurrencyDivider: Double = 1_0000.0
    
    static let minimumFee = 1.0
    
    static let transactionExtraNonceMaxCount = 255
    static let transactionExtraNonce: UInt8 = 0x02
    static let transactionExtraPaymentId: UInt8 = 0x00
    
    static let addressLength = 72
    static let addressPrefix = "abLoc"
    static let addressPrefixLength = 4
    static let addressSpendPublicKeyLength = 32
    static let addressViewPublicKeyLength = 32
    static let addressChecksumLength = 4
}
