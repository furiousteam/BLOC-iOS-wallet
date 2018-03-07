//
//  Address.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import NSData_FastHex
import CryptoSwift

/**
 Addresses are encoded in `Base58` in order to ensure human-readable strings for the following reasons:
 
 * Avoid characters that look the same in some fonts (like 0O or Il)
 * Using non-alphanumeric characters could be refused an an account number
 * Emails usually don't linkebreak if there's no punctuation
 * Double-clicking will most likely select the whole address if it only contains alphanumeric characters
 
 In the decoded address, we can find the following informations:
 
 * The `Address Prefix`, represented by the first 2 bytes. All BLOC addresses start with `0x234b` (or `b1`).
 * The `Spend Public Key` represented by the next 32 bytes.
 * The `View Public Key` represented by the next 32 bytes.
 * The `Checksum` in `Base16` represented by the last 4 bytes.
 
 To verify the checksum, take the first 66 bytes, and perform a 256-bit [keccak](https://keccak.team/index.html) (SHA3) hash. Take the first 4 bytes of the hash as a result. If the result is equal to the last 4 bytes of the decoded address, the address is valid.
 
 // TODO: Check if the following two TODOs apply to Bytecoin, might be Monero-only
 // TODO: Understand how integrated Payment ID can be embedded in the address
 // TODO: Understand how private view key can be embedded in the address
 
 In order to avoid useless dependencies and complex code, `Base58.cpp` from the core BlockChain-Coin has been reimplemented in Swift (see `Base58.swift`).
 
 The `Address` model contains all the necessary methods to manipulate a BLOC address.
 */

enum AddressError: Equatable, Error {
    case invalidBase58Encoding
    case invalidLength
    case invalidPrefix
    case invalidPublicSpendKey
    case invalidPublicViewKey
    case invalidChecksum
    case invalidHashToCheck
    case checksumFailed
}

protocol AddressModel {
    init(addressString string: String) throws

    var data: [UInt8] { get }
    var stringValue: String { get }
    var prefix: [UInt8]? { get }
    var hashToCheck: [UInt8]? { get }
    var checksum: [UInt8]? { get }
    var publicSpendKey: PublicKey? { get }
    var publicViewKey: PublicKey? { get }
    
    func validate() throws -> Bool
}

struct Address: AddressModel {
    let data: [UInt8]
    let stringValue: String
    
    init(addressString string: String) throws {
        self.stringValue = string
        
        guard let data = [UInt8](base58Decoding: stringValue) else {
            throw AddressError.invalidBase58Encoding
        }
        
        guard data.count == Constants.addressLength else {
            throw AddressError.invalidLength
        }
        
        self.data = data
    }
    
    var prefix: [UInt8]? {
        return Array(data.prefix(upTo: Constants.addressPrefixLength))
    }
    
    var publicSpendKey: PublicKey? {
        let bytes = Array(data.suffix(from: Constants.addressPrefixLength).prefix(Constants.addressSpendPublicKeyLength))
        
        return try? PublicKey(bytes)
    }
    
    var publicViewKey: PublicKey? {
        let bytes = Array(data.suffix(from: Constants.addressPrefixLength + Constants.addressSpendPublicKeyLength).prefix(Constants.addressViewPublicKeyLength))
        
        return try? PublicKey(bytes)
    }
    
    var checksum: [UInt8]? {
        return Array(data.suffix(from: Constants.addressPrefixLength + Constants.addressSpendPublicKeyLength + Constants.addressViewPublicKeyLength).prefix(Constants.addressChecksumLength))
    }
    
    var hashToCheck: [UInt8]? {
        return Array(data.prefix(upTo: Constants.addressPrefixLength + Constants.addressSpendPublicKeyLength + Constants.addressViewPublicKeyLength))
    }
    
    func validate() throws -> Bool {
        guard stringValue.hasPrefix(Constants.addressPrefix) else {
            throw AddressError.invalidPrefix
        }
        
        guard publicSpendKey != nil else {
            throw AddressError.invalidPublicSpendKey
        }
        
        guard publicViewKey != nil else {
            throw AddressError.invalidPublicViewKey
        }
        
        guard let checksum = checksum else {
            throw AddressError.invalidChecksum
        }
        
        guard let hashToCheck = hashToCheck else {
            throw AddressError.invalidHashToCheck
        }
        
        let resultChecksum = hashToCheck.sha3(.keccak256)
        let checksumBytes = Array(resultChecksum.prefix(upTo: 4))
        
        guard checksumBytes.toHexString == checksum.toHexString else {
            throw AddressError.checksumFailed
        }
        return true
    }
}
