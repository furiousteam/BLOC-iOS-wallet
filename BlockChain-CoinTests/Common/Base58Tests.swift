//
//  Base58Tests.swift
//  BlockChain-CoinTests
//
//  Created by Maxime Bornemann on 19/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import XCTest
@testable import BlockChain_Coin

let testStrings = [
    /*("", ""),
    (" ", "Z"),
    ("-", "n"),
    ("0", "q"),
    ("1", "r"),
    ("-1", "4SU"),
    ("11", "4k8"),
    ("abc", "ZiCa"),
    ("1234598760", "3mJr7AoUXx2Wqd"),
    ("abcdefghijklmnopqrstuvwxyz", "3yxU3u1igY8WkgtjK92fbJQCd4BZiiT1v25f"),
    ("00000000000000000000000000000000000000000000000000000000000000", "3sN2THZeE9Eh9eYrwkvZqNstbHGvrxSAM7gXUXvyFQP8XvQLUqNCS27icwUeDT7ckHm4FUHM2mTVh1vbLmk7y")*/
    ("b11ediMu9P4Cjmnq1G6kd67Eebs92qkq2E7bjpDCy6LAZejUzy9FZP7gBPAAk4GnMMbQ7uuQoW2Q9YAjjJ1Urnso23AYuJrsG", "b11ediMu9P4Cjmnq1G6kd67Eebs92qkq2E7bjpDCy6LAZejUzy9FZP7gBPAAk4GnMMbQ7uuQoW2Q9YAjjJ1Urnso23AYuJrsG")
]

let invalidTestStrings = [
    ("0", ""),
    ("O", ""),
    ("I", ""),
    ("l", ""),
    ("3mJr0", ""),
    ("O3yxU", ""),
    ("3sNI", ""),
    ("4kl8", ""),
    ("0OIl", ""),
    ("!@#$%^&*()-_=+~`", "")
]

class Base58StringTests: XCTestCase {
    func testEncodeBase58Strings() {
        for (decoded, encoded) in testStrings {
            let bytes = [UInt8](decoded.utf8)
            let result = String(base58Encoding: Data(bytes))
            
            XCTAssertEqual(result, encoded, "Expected encoded string: \(encoded) received: \(result)")
        }
    }
    
    func testDecodeBase58Strings() {
        for (decoded, encoded) in testStrings {
            let bytes = [UInt8](base58Decoding: encoded)
            let result = bytes?.toHexString
            
            XCTAssertEqual(result, decoded)
        }
    }
    
    func testDecodeInvalidBase58Strings() {
        for (encoded, _) in invalidTestStrings {
            let result = [UInt8](base58Decoding: encoded)
            XCTAssertNil(result)
        }
    }
}
