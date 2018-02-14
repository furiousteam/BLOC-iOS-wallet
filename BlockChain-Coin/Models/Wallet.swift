//
//  Wallet.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol WalletModel {
    var keyPair: KeyPair { get }
    var address: String { get }
    var createdAt: Date { get }
}

class Wallet: NSObject, NSCoding, WalletModel {
    let keyPair: KeyPair
    let address: String
    let createdAt: Date
    
    init(keyPair: KeyPair, address: String, createdAt: Date) {
        self.keyPair = keyPair
        self.address = address
        self.createdAt = createdAt
    }
    
    public required init?(coder aDecoder: NSCoder) {
        guard let keyPair = aDecoder.decodeObject(forKey: "keyPair") as? KeyPair,
              let address = aDecoder.decodeObject(forKey: "address") as? String,
              let createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date else { return nil }
        
        self.keyPair = keyPair
        self.address = address
        self.createdAt = createdAt
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(keyPair, forKey: "keyPair")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(createdAt, forKey: "createdAt")
    }
}
