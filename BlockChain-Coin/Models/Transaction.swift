//
//  Transaction.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol TransactionModel {
    var hash: String { get }
    var blockIndex: UInt32 { get }
    var createdAt: Date { get }
    var unlockHeight: UInt64 { get }
    var amount: Double { get }
    var fee: Double { get }
    var extra: String { get }
    var paymentId: String { get }
    var transfers: [TransferModel] { get }
}

struct Transaction: TransactionModel, Decodable {
    let hash: String
    let blockIndex: UInt32
    let createdAt: Date
    let unlockHeight: UInt64
    let amount: Double
    let fee: Double
    let extra: String
    let paymentId: String
    let transfers: [TransferModel]
    
    enum CodingKeys: String, CodingKey {
        case hash = "transactionHash"
        case blockIndex = "blockIndex"
        case createdAt = "timestamp"
        case unlockHeight = "unlockTime"
        case amount = "amount"
        case fee = "fee"
        case extra = "extra"
        case paymentId = "paymentId"
        case transfers = "transfers"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.hash = try values.decode(String.self, forKey: .hash)
        
        self.blockIndex = try values.decode(UInt32.self, forKey: .blockIndex)
        
        let createdAtTimestamp = try values.decode(Double.self, forKey: .createdAt)
        self.createdAt = Date(timeIntervalSince1970: createdAtTimestamp)
        
        self.unlockHeight = try values.decode(UInt64.self, forKey: .unlockHeight)
        
        let amountInt = try values.decode(UInt64.self, forKey: .amount)
        self.amount = Double(amountInt) / Constants.walletCurrencyDivider
        
        let feeInt = try values.decode(UInt64.self, forKey: .fee)
        self.fee = Double(feeInt) / Constants.walletCurrencyDivider
        
        self.extra = try values.decode(String.self, forKey: .extra)
        self.paymentId = try values.decode(String.self, forKey: .paymentId)
        
        let transfers = try values.decode([Transfer].self, forKey: .transfers)
        
        self.transfers = transfers.flatMap { transfer -> Transfer? in
            if transfer.address.isEmpty {
                return nil
            }
            
            return transfer
        }
    }
}
