//
//  Stats.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol StatsModel {
    var hashes: UInt { get set }
    var submittedHashes: UInt { get set }
    var lastUpdate: Date { get set }
    var hashRate: Double { get }
}

class Stats: StatsModel {
    var hashes: UInt
    var submittedHashes: UInt
    var lastUpdate: Date = Date()
    
    var hashRate: Double {
        let interval = Date().timeIntervalSince(lastUpdate)
        return TimeInterval(hashes) / interval
    }
    
    init(hashes: UInt, submittedHashes: UInt) {
        self.hashes = hashes
        self.submittedHashes = submittedHashes
    }
}
