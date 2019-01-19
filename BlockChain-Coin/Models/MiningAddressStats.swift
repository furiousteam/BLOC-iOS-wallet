//
//  MiningAddressStats.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol MiningAddressStatsModel {
    var hashes: UInt { get }
    var lastShare: Date? { get }
    var pendingBalance: Double { get }
    var paid: Double { get }
    var hashRate: String { get }
}

struct MiningAddressStats: MiningAddressStatsModel, Decodable {
    let hashes: UInt
    let lastShare: Date?
    let pendingBalance: Double
    let paid: Double
    let hashRate: String
    
    enum CodingKeys: String, CodingKey {
        case stats = "stats"
    }
    
    enum StatsCodingKeys: String, CodingKey {
        case hashes = "hashes"
        case lastShare = "lastShare"
        case pendingBalance = "balance"
        case paid = "paid"
        case hashrate = "hashrate"
    }
    
    init(hashes: UInt, lastShare: Date, pendingBalance: Double, paid: Double, hashRate: String) {
        self.hashes = hashes
        self.lastShare = lastShare
        self.pendingBalance = pendingBalance
        self.paid = paid
        self.hashRate = hashRate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let statsValues = try values.nestedContainer(keyedBy: StatsCodingKeys.self, forKey: .stats)
        
        let hashesString = try statsValues.decodeIfPresent(String.self, forKey: .hashes) ?? "0"
        self.hashes = UInt(hashesString) ?? 0
        
        if let timestampString = try statsValues.decodeIfPresent(String.self, forKey: .lastShare) {
            let timestamp = TimeInterval(timestampString) ?? 0
            self.lastShare = Date(timeIntervalSince1970: timestamp)
        } else {
            self.lastShare = nil
        }

        let balanceString = try statsValues.decodeIfPresent(String.self, forKey: .pendingBalance) ?? "0"
        self.pendingBalance = (Double(balanceString) ?? 0.0) / Constants.walletCurrencyDivider

        let paidString = try statsValues.decodeIfPresent(String.self, forKey: .paid) ?? "0"
        self.paid = (Double(paidString) ?? 0.0) / Constants.walletCurrencyDivider
        
        self.hashRate = try statsValues.decodeIfPresent(String.self, forKey: .hashrate) ?? "0 H"
    }
}
