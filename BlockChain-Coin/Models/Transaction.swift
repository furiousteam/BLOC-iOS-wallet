//
//  Transaction.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

enum TransactionType: String {
    case sent = "sent"
    case received = "received"
    
    var text: String {
        switch self {
        case .sent:
            return R.string.localizable.wallet_sent()
        case .received:
            return R.string.localizable.wallet_received()
        }
    }
    
    var smallImage: UIImage? {
        switch self {
        case .sent:
            return R.image.sentSmall()
        case .received:
            return R.image.receivedSmall()
        }
    }
}

protocol TransactionModel {
    var hash: String { get }
    var blockIndex: UInt32 { get }
    var createdAt: Date { get }
    var unlockHeight: UInt64 { get }
    var amount: Double { get }
    var fee: Double { get }
    var extra: String { get }
    var paymentId: String { get }
    var transfers: [Transfer] { get }
    var transactionType: TransactionType { get }
}

struct Transaction: TransactionModel, Codable {
    let hash: String
    let blockIndex: UInt32
    let createdAt: Date
    let unlockHeight: UInt64
    let amount: Double
    let fee: Double
    let extra: String
    let paymentId: String
    let transfers: [Transfer]
    
    var transactionType: TransactionType {
        if amount < 0 {
            return .sent
        }
        
        return .received
    }
    
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
        case transactionType = "transactionType"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hash, forKey: .hash)
        try container.encode(blockIndex, forKey: .blockIndex)
        try container.encode(Date.isoDateFormatter.string(from: createdAt), forKey: .createdAt)
        try container.encode(unlockHeight, forKey: .unlockHeight)
        try container.encode(amount, forKey: .amount)
        try container.encode(fee, forKey: .fee)
        try container.encode(extra, forKey: .extra)
        try container.encode(paymentId, forKey: .paymentId)
        try container.encode(transfers, forKey: .transfers)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.hash = try values.decode(String.self, forKey: .hash)
        
        self.blockIndex = try values.decode(UInt32.self, forKey: .blockIndex)
        
        let createdAtString = try values.decode(String.self, forKey: .createdAt)
        self.createdAt = Date.isoDateFormatter.date(from: createdAtString) ?? Date()
        
        self.unlockHeight = try values.decode(UInt64.self, forKey: .unlockHeight)
        
        let amountInt = try values.decode(Double.self, forKey: .amount)
        self.amount = amountInt / Constants.walletCurrencyDivider
        
        let feeInt = try values.decode(Double.self, forKey: .fee)
        self.fee = feeInt / Constants.walletCurrencyDivider
        
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
