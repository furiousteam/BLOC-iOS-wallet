//
//  WalletSocketAddResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

// {"id":"0","jsonrpc":"2.0","result":{"address":"xxx"}}

protocol WalletSocketAddResponseModel {
    var address: String { get }
}

class WalletSocketAddResponse: WalletSocketAddResponseModel, Decodable {
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
    
    enum ResultCodingKeys: String, CodingKey {
        case address = "address"
    }
    
    init(address: String) {
        self.address = address
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let resultValues = try values.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .result)
        
        address = try resultValues.decode(String.self, forKey: .address)
    }
}
