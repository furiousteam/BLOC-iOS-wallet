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
    var name: String { get }
    var details: WalletDetails? { get }
}

class Wallet: WalletModel, Codable {
    let uuid: UUID
    let keyPair: KeyPair
    let address: String
    let createdAt: Date
    let name: String
    var details: WalletDetails?
    
    var password: String? {
        return KeychainWrapper.standard.string(forKey: uuid.uuidString)
    }
    
    init(uuid: UUID, keyPair: KeyPair, address: String, password: String, name: String, details: WalletDetails?, createdAt: Date) {
        self.uuid = uuid
        self.keyPair = keyPair
        self.address = address
        self.createdAt = createdAt
        self.details = details
        self.name = name
        
        KeychainWrapper.standard.set(password, forKey: uuid.uuidString)
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case keyPair = "keyPair"
        case address = "address"
        case createdAt = "createdAt"
        case details = "details"
        case name = "name"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(uuid, forKey: .uuid)
        try container.encode(keyPair, forKey: .keyPair)
        try container.encode(address, forKey: .address)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(details, forKey: .details)
        try container.encode(name, forKey: .name)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.uuid = try values.decode(UUID.self, forKey: .uuid)
        
        self.keyPair = try values.decode(KeyPair.self, forKey: .keyPair)
        
        self.address = try values.decode(String.self, forKey: .address)
        
        self.createdAt = try values.decode(Date.self, forKey: .createdAt)
        
        self.details = try values.decodeIfPresent(WalletDetails.self, forKey: .details)
        
        self.name = try values.decode(String.self, forKey: .name)
    }
}
