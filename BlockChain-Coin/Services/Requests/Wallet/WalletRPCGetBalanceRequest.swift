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
// {"error":{"code":-32000,"data":{"application_code":20},"message":"Address already exists"},"id":"0","jsonrpc":"2.0"}

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
           let availableBalance = json["availableBalance"] as? UInt64,
           let lockedBalance = json["lockedAmount"] as? UInt64 {
            let div: Double = 10000000.0
            return WalletRPCGetBalanceResponse(availableBalance: Double(availableBalance) / div, lockedBalance: Double(lockedBalance) / div)
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
        
    }
}
