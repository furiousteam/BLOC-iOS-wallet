//
//  PoolSocketOKResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol PoolSocketOKResponseModel {
    var status: String { get }
}

class PoolSocketOKResponse: PoolSocketOKResponseModel, Decodable {
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
    
    enum ResultCodingKeys: String, CodingKey {
        case status = "status"
    }
    
    init(status: String) {
        self.status = status
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let resultValues = try values.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .result)
        
        status = try resultValues.decode(String.self, forKey: .status)
    }
}
