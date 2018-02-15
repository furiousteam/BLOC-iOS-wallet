//
//  WalletRPCGetBalanceRequest.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import JSONRPCKit
import APIKit

// curl -X POST localhost:8070/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"getBalance", "params":{ "address": "xxx" }}' -H 'Content-Type: application/json'
//
// {"id":"0","jsonrpc":"2.0","result":{"address":"xxx"}}

// TODO: Handle error responses

struct WalletRPCGetBalanceRequest: JSONRPCKit.Request {
    typealias Response = WalletRPCGetBalanceResponse
    
    let address: String
    
    var method: String {
        return "getBalance"
    }
    
    var parameters: Any? {
        return [ "address": address ]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let json = resultObject as? [String: Any],
           let data = try? JSONSerialization.data(withJSONObject: json, options: [ ]),
           let response = try? JSONDecoder().decode(WalletRPCGetBalanceResponse.self, from: data) {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}
