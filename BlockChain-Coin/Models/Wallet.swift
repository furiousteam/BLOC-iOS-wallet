//
//  Wallet.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

protocol WalletModel {
    var uuid: UUID { get }
    var keyPair: KeyPair { get }
    var address: String { get }
    var createdAt: Date { get }
    var password: String? { get }
}

class Wallet: NSObject, NSCoding, WalletModel {
    let uuid: UUID
    let keyPair: KeyPair
    let address: String
    let createdAt: Date
    
    var password: String? {
        return KeychainWrapper.standard.string(forKey: uuid.uuidString)
    }
    
    init(uuid: UUID, keyPair: KeyPair, address: String, password: String, createdAt: Date) {
        self.uuid = uuid
        self.keyPair = keyPair
        self.address = address
        self.createdAt = createdAt
        
        KeychainWrapper.standard.set(password, forKey: uuid.uuidString)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        guard let uuid = aDecoder.decodeObject(forKey: "uuid") as? UUID,
              let keyPair = aDecoder.decodeObject(forKey: "keyPair") as? KeyPair,
              let address = aDecoder.decodeObject(forKey: "address") as? String,
              let createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date else { return nil }
        
        self.uuid = uuid
        self.keyPair = keyPair
        self.address = address
        self.createdAt = createdAt
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(keyPair, forKey: "keyPair")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(createdAt, forKey: "createdAt")
    }
}
