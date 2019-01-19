//
//  String+Bytes.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

extension String {
    var toBytes: [UInt8] {
        let hex = Array(self)
        return stride(from: 0, to: count, by: 2).flatMap { UInt8(String(hex[$0..<$0.advanced(by: 2)]), radix: 16) }
    }
}
