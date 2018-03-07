//
//  TransactionExtra.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct TransactionExtraField {
    var data: [UInt8]
    var tag: UInt8
}

class TransactionExtra {
    let extraFields: [TransactionExtraField]
    
    var bytes: [UInt8] {
        return extraFields.reduce([UInt8]()) { (bytes, field) -> [UInt8] in
            do {
                return try add(extra: field.data, to: bytes, tag: field.tag)
            } catch {
                print("Invalid extra field, ignoring")
                return bytes
            }
        }
    }
    
    init(extraFields: [TransactionExtraField]) {
        self.extraFields = extraFields
    }
    
    func add(extra: [UInt8], to: [UInt8], tag: UInt8) throws -> [UInt8] {
        guard extra.count <= Constants.transactionExtraNonceMaxCount else {
            throw TransactionStoreError.invalidExtraNonceSize
        }
        
        var bytes = to
        
        // Write tag
        bytes.append(Constants.transactionExtraNonce)
        
        // Write length
        bytes.append(UInt8(extra.count))
        
        // Write data
        bytes.append(tag)
        bytes.append(contentsOf: extra)
        
        return bytes
    }
}
