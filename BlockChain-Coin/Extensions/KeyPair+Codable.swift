//
//  KeyPair+Codable.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 21/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

extension KeyPair: Codable {
    enum CodingKeys: String, CodingKey {
        case publicKey = "publicKey"
        case privateKey = "privateKey"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(publicKey, forKey: .publicKey)
        try container.encode(privateKey, forKey: .privateKey)
    }
    
    public convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let publicKey = try values.decode(PublicKey.self, forKey: .publicKey)
        
        let privateKey = try values.decode(PrivateKey.self, forKey: .privateKey)
        
        self.init(publicKey: publicKey, privateKey: privateKey)
    }
}

extension PublicKey: Codable {
    enum CodingKeys: String, CodingKey {
        case buffer = "buffer"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(bytes, forKey: .buffer)
    }
    
    public convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let buffer = try values.decode([UInt8].self, forKey: .buffer)
        
        try self.init(buffer)
    }

}

extension PrivateKey: Codable {
    enum CodingKeys: String, CodingKey {
        case buffer = "buffer"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(bytes, forKey: .buffer)
    }
    
    public convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let buffer = try values.decode([UInt8].self, forKey: .buffer)
        
        try self.init(buffer)
    }
    
}
