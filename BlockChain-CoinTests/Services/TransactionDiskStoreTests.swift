//
//  TransactionDiskStoreTests.swift
//  BlockChain-CoinTests
//
//  Created by Maxime Bornemann on 19/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import XCTest
@testable import BlockChain_Coin

class TransactionDiskStoreTests: XCTestCase {
    let service = TransactionDiskStore()
    let walletService = WalletDiskStore()
    
    func testTransaction() {
        let addressA = try! Address(addressString: "b12FVD28FByg3kHjjEE7qo4goackaCLMPVaFiNEFscPo7wrppjQnr8R3NYui3ZcSHFNGLvHDAqk6FeVbgdg71VyX1nhqHEbSi")
        let destA = TransactionDestination(address: addressA, amount: UInt64(Constants.minimumFee))
        let destinations = [ destA ]
        
        let seed = walletService.generateSeed()
        let keyPair = walletService.generateKeyPair(seed: seed!)
        
        service.send(destinations: destinations, mixin: 0, paymentId: nil, fee: UInt64(Constants.minimumFee), keyPair: keyPair!) { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
        
        sleep(100)
    }
    
}
