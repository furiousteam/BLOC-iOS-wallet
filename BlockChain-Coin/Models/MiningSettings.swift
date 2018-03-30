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
    var host: String { get }
    var port: Int { get }
    var stats: PoolStats? { get set }
}

struct MiningPool: MiningPoolModel, Codable {
    let host: String
    let port: Int
    var stats: PoolStats?
    
    enum CodingKeys: String, CodingKey {
        case host = "host"
        case port = "port"
        case stats = "stats"
    }

    init(host: String, port: Int, stats: PoolStats?) {
        self.host = host
        self.port = port
        self.stats = stats
    }
}

protocol MiningSettingsModel {
    var threads: UInt { get }
    var power: MiningPower { get }
    var wallet: Wallet { get }
    var pool: MiningPool { get }
}

struct MiningSettings: MiningSettingsModel, Codable {
    let threads: UInt
    let wallet: Wallet
    let pool: MiningPool
    
    var power: MiningPower {
        return MiningPower(threads: threads)
    }
    
    enum CodingKeys: String, CodingKey {
        case threads = "threads"
        case wallet = "wallet"
        case pool = "pool"
    }

    init(threads: UInt, wallet: Wallet, pool: MiningPool) {
        self.threads = threads
        self.wallet = wallet
        self.pool = pool
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(threads, forKey: .threads)
        try container.encode(wallet, forKey: .wallet)
        try container.encode(pool, forKey: .pool)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.threads = try values.decode(UInt.self, forKey: .threads)
        
        self.wallet = try values.decode(Wallet.self, forKey: .wallet)
        
        self.pool = try values.decode(MiningPool.self, forKey: .pool)
    }
}
