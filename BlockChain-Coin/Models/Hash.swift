//
//  Hash.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

public class Hash {
    private let buffer: [UInt8]
    
    public init(_ bytes: [UInt8]) throws {
        guard bytes.count == 32 else {
            throw Ed25519Error.invalidHashLength
        }
        
        self.buffer = bytes
    }
    
    init(unchecked buffer: [UInt8]) {
        self.buffer = buffer
    }
    
    public var bytes: [UInt8] {
        return buffer
    }
}
