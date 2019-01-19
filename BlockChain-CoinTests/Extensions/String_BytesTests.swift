//
//  String_BytesTests.swift
//  BlockChain-CoinTests
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

@testable import BlockChain_Coin
import XCTest

class String_BytesTests: XCTestCase {
    func testConvertsStringToBytes() {
        let hexString = "3700679d93a9e1ea077fa2e6d63a0599e78cf7f1a373c9880d786d4761604601"

        let bytes: [UInt8] = [ 0x37, 0x00, 0x67, 0x9D,
                               0x93, 0xA9, 0xE1, 0xEA,
                               0x07, 0x7f, 0xA2, 0xE6,
                               0xD6, 0x3A, 0x05, 0x99,
                               0xE7, 0x8C, 0xF7, 0xF1,
                               0xA3, 0x73, 0xC9, 0x88,
                               0x0D, 0x78, 0x6D, 0x47,
                               0x61, 0x60, 0x46, 0x01  ]

        
        let bytesFromHex = hexString.toBytes
        
        XCTAssert(bytesFromHex.count == bytes.count)
        XCTAssert(bytesFromHex == bytes)
    }
    
}
