//
//  WalletAPICreateResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol WalletAPICreateResponseModel {
    var address: String { get }
}

class WalletAPICreateResponse: WalletAPICreateResponseModel, Decodable {
    enum CodingKeys: String, CodingKey {
        case address = "address"
    }
    
    let address: String
    
    init(address: String) {
        self.address = address
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        address = try values.decode(String.self, forKey: .address)
    }
    
}
