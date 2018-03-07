//
//  Response+ErrorHandling.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

import Foundation
import Moya

public extension Response {
    
    /// Filters out responses that don't fall within the 200...299 range, and returns a known Ophta error
    public func handleErrorIfNeeded() throws -> Response {
        guard (200...299).contains(statusCode) else {
            /*let error = try JSONDecoder().decode(APIError.self, from: data)
            
            log.error(error)
            
            throw NSError(domain: "com.traakx", code: error.error, userInfo: [ "message": error.message ])*/
            
            // TODO: Parse custom error object
            throw MoyaError.statusCode(self)
        }
        
        return self
    }
}
