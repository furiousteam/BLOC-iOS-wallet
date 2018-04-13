//
//  PoolSocketErrorResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 03/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

class PoolSocketErrorResponse: Decodable {
    var code: Int
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case error = "error"
    }
    
    enum ErrorCodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
    
    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let errorValues = try values.nestedContainer(keyedBy: ErrorCodingKeys.self, forKey: .error)
        
        code = try errorValues.decode(Int.self, forKey: .code)
        message = try errorValues.decode(String.self, forKey: .message)
    }
}
