//
//  WalletRPCGetTransactionsRequest.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import JSONRPCKit
import APIKit

struct WalletRPCGetTransactionsRequest: JSONRPCKit.Request {
    typealias Response = [Transaction]
    
    let address: String
    
    var method: String {
        return "getTransactions"
    }
    
    var parameters: Any? {
        return [ "addresses": [ address ],
                 "blockCount": UInt32.max,
                 "firstBlockIndex": UInt32.min ]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let json = resultObject as? [String: Any],
            let data = try? JSONSerialization.data(withJSONObject: json, options: [ ]),
            let response = try? JSONDecoder().decode(WalletRPCGetTransactionsResponse.self, from: data) {
            return response.items.flatMap({ $0.transactions })
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
