//
//  PoolStats.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol PoolStatsModel {
    var fee: Double { get }
    var hashRate: Int { get }
    var miners: Int { get }
    var lastBlockFound: Date { get }
    var blockTime: UInt { get }
    var networkHashRate: UInt { get }
    var networkLastBlockFound: Date { get }
    var networkDifficulty: UInt { get }
    var networkHeight: UInt { get }
    var lastReward: Double { get }

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
    let fee: Double
    let hashRate: Int
    let miners: Int
    let lastBlockFound: Date
    let blockTime: UInt
    let networkHashRate: UInt
    let networkLastBlockFound: Date
    let networkDifficulty: UInt
    let networkHeight: UInt
    let lastReward: Double
    
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
        case network = "network"
    }
    
    enum ConfigCodingKeys: String, CodingKey {
        case fee = "fee"
        case blockTime = "blockTime"
        case coinDifficultyTarget = "coinDifficultyTarget"
    }
    
    enum PoolCodingKeys: String, CodingKey {
        case hashRate = "hashrate"
        case miners = "miners"
        case stats = "stats"
    }
    
    enum PoolStatsCodingKeys: String, CodingKey {
        case lastBlockFound = "lastBlockFound"
    }
    
    enum NetworkCodingKeys: String, CodingKey {
        case difficulty = "difficulty"
        case timestamp = "timestamp"
        case height = "height"
        case reward = "reward"
    }
    
    enum EncodeCodingKeys: String, CodingKey {
        case fee = "fee"
        case hashRate = "hashRate"
        case miners = "miners"
        case lastBlockFound = "lastBlockFound"
        case blockTime = "blockTime"
    }
    
    init(fee: Double, hashRate: Int, miners: Int, lastBlockFound: Date, blockTime: UInt, networkHashRate: UInt, networkLastBlockFound: Date, networkDifficulty: UInt, networkHeight: UInt, lastReward: Double) {
        self.fee = fee
        self.hashRate = hashRate
        self.miners = miners
        self.lastBlockFound = lastBlockFound
        self.blockTime = blockTime
        self.networkHashRate = networkHashRate
        self.networkLastBlockFound = networkLastBlockFound
        self.networkHeight = networkHeight
        self.networkDifficulty = networkDifficulty
        self.lastReward = lastReward
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let configValues = try values.nestedContainer(keyedBy: ConfigCodingKeys.self, forKey: .config)
        
        self.fee = try configValues.decode(Double.self, forKey: .fee)
        self.blockTime = try configValues.decode(UInt.self, forKey: .blockTime)
        
        let poolValues = try values.nestedContainer(keyedBy: PoolCodingKeys.self, forKey: .pool)

        self.hashRate = try poolValues.decode(Int.self, forKey: .hashRate)
        self.miners = try poolValues.decode(Int.self, forKey: .miners)
        
        let poolStatsValues = try poolValues.nestedContainer(keyedBy: PoolStatsCodingKeys.self, forKey: .stats)
        
        let timestampString = try poolStatsValues.decode(String.self, forKey: .lastBlockFound)
        let timestamp = (TimeInterval(timestampString) ?? 0) / 1000
        self.lastBlockFound = Date(timeIntervalSince1970: timestamp)
        
        let networkValues = try values.nestedContainer(keyedBy: NetworkCodingKeys.self, forKey: .network)
        self.networkDifficulty = try networkValues.decodeIfPresent(UInt.self, forKey: .difficulty) ?? 0
        let coinDifficultyTarget = try configValues.decodeIfPresent(UInt.self, forKey: .coinDifficultyTarget) ?? 1
        self.networkHashRate = UInt(floor(Double(networkDifficulty) / Double(coinDifficultyTarget)))
        
        let networkTimestampString = try networkValues.decode(UInt.self, forKey: .timestamp)
        let networkTimestamp = TimeInterval(networkTimestampString)
        self.networkLastBlockFound = Date(timeIntervalSince1970: networkTimestamp)
        
        self.networkHeight = try networkValues.decode(UInt.self, forKey: .height)
        self.lastReward = Double(try networkValues.decode(UInt.self, forKey: .reward)) / Constants.walletCurrencyDivider
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodeCodingKeys.self)
        
        try container.encode(fee, forKey: .fee)
        try container.encode(hashRate, forKey: .hashRate)
        try container.encode(miners, forKey: .miners)
        try container.encode(lastBlockFound, forKey: .lastBlockFound)
        try container.encode(blockTime, forKey: .blockTime)
    }

}
