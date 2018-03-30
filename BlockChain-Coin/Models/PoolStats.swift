//
//  PoolStats.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol PoolStatsModel {
    var fee: Int { get }
    var hashRate: Int { get }
    var miners: Int { get }
    var lastBlockFound: Date { get }
    
    var shortDescription: String { get }
}

class UnitHash: Dimension {
    static var HashPerSec: UnitHash = UnitHash(symbol: "H/sec", converter: UnitConverterLinear(coefficient: 1))
    static var KiloHashPerSec: UnitHash = UnitHash(symbol: "kH/sec", converter: UnitConverterLinear(coefficient: 1_000))
    static var MegaHashPerSec: UnitHash = UnitHash(symbol: "mH/sec", converter: UnitConverterLinear(coefficient: 1_000_000))
    static var GigaHashPerSec: UnitHash = UnitHash(symbol: "gH/sec", converter: UnitConverterLinear(coefficient: 1_000_000_000))
    
    override static func baseUnit() -> UnitHash { return UnitHash.HashPerSec }
}

struct PoolStats: PoolStatsModel, Codable {
    let fee: Int
    let hashRate: Int
    let miners: Int
    let lastBlockFound: Date
    
    var shortDescription: String {
        let feeString = "\(fee)%"
        let minersString = "\(miners)"

        let hashRateMeasurement: Measurement = {
            if hashRate < 1_000 {
                return Measurement(value: Double(hashRate), unit: UnitHash.HashPerSec)
            } else if hashRate < 1_000_000 {
                return Measurement(value: Double(hashRate) / 1_000, unit: UnitHash.KiloHashPerSec)
            } else if hashRate < 1_000_000_000 {
                return Measurement(value: Double(hashRate) / 1_000_000, unit: UnitHash.MegaHashPerSec)
            } else {
                return Measurement(value: Double(hashRate) / 1_000_000_000, unit: UnitHash.GigaHashPerSec)
            }
        }()

        return R.string.localizable.mining_pool_list_description(feeString, String(describing: hashRateMeasurement), minersString, lastBlockFound.relativeShortDate())
    }
    
    enum CodingKeys: String, CodingKey {
        case config = "config"
        case pool = "pool"
    }
    
    enum ConfigCodingKeys: String, CodingKey {
        case fee = "fee"
    }
    
    enum PoolCodingKeys: String, CodingKey {
        case hashRate = "hashrate"
        case miners = "miners"
        case lastBlockFound = "lastBlockFound"
    }
    
    enum EncodeCodingKeys: String, CodingKey {
        case fee = "fee"
        case hashRate = "hashRate"
        case miners = "miners"
        case lastBlockFound = "lastBlockFound"
    }
    
    init(fee: Int, hashRate: Int, miners: Int, lastBlockFound: Date) {
        self.fee = fee
        self.hashRate = hashRate
        self.miners = miners
        self.lastBlockFound = lastBlockFound
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let configValues = try values.nestedContainer(keyedBy: ConfigCodingKeys.self, forKey: .config)
        
        self.fee = try configValues.decode(Int.self, forKey: .fee)
        
        let poolValues = try values.nestedContainer(keyedBy: PoolCodingKeys.self, forKey: .pool)

        self.hashRate = try poolValues.decode(Int.self, forKey: .hashRate)
        self.miners = try poolValues.decode(Int.self, forKey: .miners)
        
        let timestampString = try poolValues.decode(String.self, forKey: .lastBlockFound)
        let timestamp = TimeInterval(timestampString) ?? 0
        self.lastBlockFound = Date(timeIntervalSince1970: timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodeCodingKeys.self)
        
        try container.encode(fee, forKey: .fee)
        try container.encode(hashRate, forKey: .hashRate)
        try container.encode(miners, forKey: .miners)
        try container.encode(lastBlockFound, forKey: .lastBlockFound)
    }

}
