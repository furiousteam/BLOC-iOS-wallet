//
//  Stats.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol StatsModel {
    var hashes: UInt { get set }
    var submittedHashes: UInt { get set }
    var lastUpdate: Date { get set }
    var lastUpdateDispatch: Date { get set }
    var hashRate: Double { get }
    var allTimeHashes: UInt64 { get set }
}

class Stats: StatsModel {
    var hashes: UInt
    var submittedHashes: UInt
    var allTimeHashes: UInt64
    var lastUpdate: Date = Date()
    var lastUpdateDispatch: Date = Date()
    
    var hashRate: Double {
        let interval = Date().timeIntervalSince(lastUpdate)
        return TimeInterval(hashes) / interval
    }
    
    init(hashes: UInt, submittedHashes: UInt, allTimeHashes: UInt64) {
        self.hashes = hashes
        self.submittedHashes = submittedHashes
        self.allTimeHashes = allTimeHashes
    }
}
