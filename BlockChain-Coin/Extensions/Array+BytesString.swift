//
//  Array+BytesString.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation
import NSData_FastHex

extension Array where Element == UInt8 {
    var toHexString: String {
        let data = NSData(bytes: self, length: self.count)
        return data.hexStringRepresentationUppercase(false)
    }
}
