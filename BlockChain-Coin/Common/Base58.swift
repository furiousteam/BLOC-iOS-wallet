//
//  Base58.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 19/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation
import BigInt

public enum Base58Alphabet {
    public static let bytecoinAlphabet = [UInt8]("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".utf8)
}

public extension String {
    
    public init(base58Encoding bytes: Data, alphabet: [UInt8] = Base58Alphabet.bytecoinAlphabet) {
        var x = BigUInt(bytes)
        let radix = BigUInt(alphabet.count)
        
        var answer = [UInt8]()
        answer.reserveCapacity(bytes.count)
        
        while x > 0 {
            let (quotient, modulus) = x.quotientAndRemainder(dividingBy: radix)
            answer.append(alphabet[Int(modulus)])
            x = quotient
        }
        
        let prefix = Array(bytes.prefix(while: {$0 == 0})).map { _ in alphabet[0] }
        answer.append(contentsOf: prefix)
        answer.reverse()
        
        self = String(bytes: answer, encoding: String.Encoding.utf8)!
    }
    
}

public extension Array where Element == UInt8 {
    
    public init?(base58Decoding string: String, alphabet: [UInt8] = Base58Alphabet.bytecoinAlphabet) {
        let fullEncodedBlockSize = 11
        let encodedBlockSizes = [ 0, 2, 3, 5, 6, 7, 9, 10, 11 ];
        let fullBlockSize = 8
        
        func uInt64To8Be(num: BigUInt, size: Int) -> [UInt8] {
            var res = [UInt8](repeating: 0, count: size)
            var innerNum = num
            
            if size < 1 || size > 8 {
                return []
            }
            
            let twoPow8 = BigUInt(2).power(8)
            
            for i in (0...size - 1).reversed() {
                res[i] = UInt8(innerNum.quotientAndRemainder(dividingBy: twoPow8).remainder)
                innerNum = innerNum.quotientAndRemainder(dividingBy: twoPow8).quotient
            }
            
            return res
        }
        
        func decodeBlock(data: [UInt8], buffer: [UInt8], index: Int) -> [UInt8] {
            if data.count < 1 || data.count > fullEncodedBlockSize {
                log.error("Invalid block length: \(data.count)")
                return buffer
            }
            
            guard let resSize = encodedBlockSizes.index(of: data.count), resSize > 0 else {
                log.error("Invalid block size")
                return buffer
            }
            
            var resNum = BigUInt(0)
            var order = BigUInt(1)
            
            for i in (0...data.count - 1).reversed() {
                guard let digit = alphabet.index(of: data[i]), digit >= 0 else {
                    log.error("Invalid symbol")
                    break
                }
                
                let product = order.multiplied(by: BigUInt(digit)) + resNum
                
                if (product > UInt64.max) {
                    log.error("Overflow")
                    break
                }
                
                resNum = product
                order = order.multiplied(by: BigUInt(alphabet.count))
            }
            
            if (resSize < fullBlockSize && BigUInt(2).power(8 * resSize) <= resNum) {
                log.error("Overflow 2")
                return buffer
            }
            
            var resultBuffer = buffer
            
            let bytes = uInt64To8Be(num: resNum, size: resSize)
            
            for i in (index...index + bytes.count - 1) {
                resultBuffer[i] = bytes[i - index]
            }
            
            return resultBuffer;
        }
        
        let stringBytes = [UInt8](string.utf8)
        
        guard stringBytes.count != 0 else { return nil }
        
        let fullBlockCount = stringBytes.count / fullEncodedBlockSize
        let lastBlockSize = stringBytes.count % fullEncodedBlockSize
        
        guard let lastBlockDecodedSize = encodedBlockSizes.index(of: lastBlockSize), lastBlockDecodedSize >= 0 else {
            print("Invalid encoded length")
            return nil
        }
        
        let dataSize = fullBlockCount * fullBlockSize + lastBlockDecodedSize
        var data = [UInt8](repeating: 0, count: dataSize)
        
        for i in 0...fullBlockCount {
            let toEncode = Array(stringBytes.suffix(from: i * fullEncodedBlockSize).prefix(fullEncodedBlockSize))
            data = decodeBlock(data: toEncode, buffer: data, index: i * fullBlockSize)
        }
        
        if lastBlockSize > 0 {
            let toEncode = Array(stringBytes.suffix(from: fullBlockCount * fullEncodedBlockSize).prefix(fullBlockCount * fullEncodedBlockSize + lastBlockSize))
            data = decodeBlock(data: toEncode, buffer: data, index: fullBlockCount * fullBlockSize)
        }
        
        self = data
        
        /*var answer = BigUInt(0)
        var j = BigUInt(1)
        let radix = BigUInt(alphabet.count)
        let byteString = [UInt8](string.utf8)
        
        for ch in byteString.reversed() {
            if let index = alphabet.index(of: ch) {
                answer = answer + (j * BigUInt(index))
                j *= radix
            } else {
                return nil
            }
        }
        
        let bytes = answer.serialize()
        self = byteString.prefix(while: { i in i == alphabet[0]}) + bytes*/
    }
    
}

