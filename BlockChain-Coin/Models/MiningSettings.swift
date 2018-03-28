//
//  MiningSettings.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 28/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

enum MiningPower: String {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case intense = "intense"
    
    init(threads: UInt) {
        let numberOfThreads = ProcessInfo.processInfo.activeProcessorCount
        
        let ratio = Double(threads) / Double(numberOfThreads)
        
        switch ratio {
        case 0.0...0.24:
            self = .low
        case 0.25...0.49:
            self = .medium
        case 0.50...0.74:
            self = .high
        case 0.75...1.0:
            self = .intense
        default:
            self = .medium
        }
    }
    
    var readableString: String {
        switch self {
        case .low:
            return R.string.localizable.mining_number_of_threads_low()
        case .medium:
            return R.string.localizable.mining_number_of_threads_medium()
        case .high:
            return R.string.localizable.mining_number_of_threads_high()
        case .intense:
            return R.string.localizable.mining_number_of_threads_intense()
        }
    }
}

protocol MiningPoolModel: Codable {
    var url: URL { get }
}

struct MiningPool: MiningPoolModel {
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }

    init(url: URL) {
        self.url = url
    }
}

protocol MiningSettingsModel {
    var power: MiningPower { get }
    var wallet: Wallet { get }
    var pool: MiningPool { get }
}

struct MiningSettings: MiningSettingsModel, Codable {
    let power: MiningPower
    let wallet: Wallet
    let pool: MiningPool
    
    enum CodingKeys: String, CodingKey {
        case power = "power"
        case wallet = "wallet"
        case pool = "pool"
    }

    init(power: MiningPower, wallet: Wallet, pool: MiningPool) {
        self.power = power
        self.wallet = wallet
        self.pool = pool
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(power.rawValue, forKey: .power)
        try container.encode(wallet, forKey: .wallet)
        try container.encode(pool, forKey: .pool)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let powerString = try values.decode(String.self, forKey: .power)
        self.power = MiningPower(rawValue: powerString) ?? .medium
        
        self.wallet = try values.decode(Wallet.self, forKey: .wallet)
        
        self.pool = try values.decode(MiningPool.self, forKey: .pool)
    }
}
