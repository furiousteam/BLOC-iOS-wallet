//
//  AddressTests.swift
//  BlockChain-CoinTests
//
//  Created by Maxime Bornemann on 19/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import XCTest
@testable import BlockChain_Coin

class AddressTests: XCTestCase {
    
    let validAddress = "b11ediMu9P4Cjmnq1G6kd67Eebs92qkq2E7bjpDCy6LAZejUzy9FZP7gBPAAk4GnMMbQ7uuQoW2Q9YAjjJ1Urnso23AYuJrsG"
    let invalidPrefixAddress = "b21ediMu9P4Cjmnq1G6kd67Eebs92qkq2E7bjpDCy6LAZejUzy9FZP7gBPAAk4GnMMbQ7uuQoW2Q9YAjjJ1Urnso23AYuJrsG"

    func testValidAddress() {
        let address = try? Address(addressString: validAddress)
        
        XCTAssertNotNil(address)
        XCTAssertTrue(try! address!.validate())
    }
    
    func testCanExtractPrefixFromValidAddress() {
        let address = try? Address(addressString: validAddress)
        
        let prefix = address?.prefix
        
        XCTAssertNotNil(prefix)
        XCTAssertTrue(prefix?.toHexString == "cb46")
    }

    func testCanExtractPublicSpendKeyFromValidAddress() {
        let address = try? Address(addressString: validAddress)
        
        let publicSpendKey = address?.publicSpendKey
        
        XCTAssertNotNil(publicSpendKey)
        XCTAssertTrue(publicSpendKey?.bytes.toHexString == "1c752a36279f462c73e42328247125474cc6bcbaedfd4e66f269f54d82bbc334")
    }

    func testCanExtractPublicViewKeyFromValidAddress() {
        let address = try? Address(addressString: validAddress)
        
        let publicViewKey = address?.publicViewKey
        
        XCTAssertNotNil(publicViewKey)
        XCTAssertTrue(publicViewKey?.bytes.toHexString == "7714743186f2ea3c66937634f218cda7e488a6ec3e2aba572dfc1826906e78d1")
    }
    
    func testCanExtractChecksumFromValidAddress() {
        let address = try? Address(addressString: validAddress)
        
        let checksum = address?.checksum
        
        XCTAssertNotNil(checksum)
        XCTAssertTrue(checksum?.toHexString == "d46b1fcf")
    }
    
    func testCanExtractHashToCheckFromValidAddress() {
        let address = try? Address(addressString: validAddress)
        
        let hashToCheck = address?.hashToCheck
        
        XCTAssertNotNil(hashToCheck)
        XCTAssertTrue(hashToCheck?.toHexString == "cb461c752a36279f462c73e42328247125474cc6bcbaedfd4e66f269f54d82bbc3347714743186f2ea3c66937634f218cda7e488a6ec3e2aba572dfc1826906e78d1")
    }
    
    func testInvalidAddressPrefix() {
        let address = try? Address(addressString: invalidPrefixAddress)
        
        XCTAssertNotNil(address)
        
        XCTAssertThrowsError(try address?.validate()) { error in
            XCTAssertEqual(error as? AddressError, AddressError.invalidPrefix)
        }
    }
}
