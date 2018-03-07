//
//  WalletAPIKeysResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol WalletKeysModel {
    var spendPublicKey: String { get }
    var viewPublicKey: String { get }
    var spendPrivateKey: String { get }
    var viewPrivateKey: String { get }
}

class WalletKeys: WalletKeysModel, Decodable {
    enum CodingKeys: String, CodingKey {
        case spendPublicKey = "spendPublicKey"
        case viewPublicKey = "viewPublicKey"
        case spendPrivateKey = "spendPrivateKey"
        case viewPrivateKey = "viewPrivateKey"
    }
    
    let spendPublicKey: String
    let viewPublicKey: String
    let spendPrivateKey: String
    let viewPrivateKey: String
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.spendPublicKey = try values.decode(String.self, forKey: .spendPublicKey)
        self.viewPublicKey = try values.decode(String.self, forKey: .viewPublicKey)
        self.spendPrivateKey = try values.decode(String.self, forKey: .spendPrivateKey)
        self.viewPrivateKey = try values.decode(String.self, forKey: .spendPrivateKey)
    }
    
}
