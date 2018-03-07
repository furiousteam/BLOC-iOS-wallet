//
//  TransactionExtraTests.swift
//  BlockChain-CoinTests
//
//  Created by Maxime Bornemann on 16/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

// TODO:
// - should add multiple field

import XCTest
@testable import BlockChain_Coin

class TransactionExtraTests: XCTestCase {
    func testAddExtraPaymentId() {
        let paymentId = "3700679d93a9e1ea077fa2e6d63a0599e78cf7f1a373c9880d786d4761604601"
        let paymentIdBytes = paymentId.toBytes
        let paymentIdField = TransactionExtraField(data: paymentIdBytes, tag: Constants.transactionExtraPaymentId)
        
        let transactionExtra = TransactionExtra(extraFields: [ paymentIdField ])
        
        let result = transactionExtra.bytes
        
        XCTAssert(result.count == (paymentIdBytes.count + 3))
        XCTAssert(result[0] == Constants.transactionExtraNonce)
        XCTAssert(result[1] == UInt(paymentIdBytes.count))
        XCTAssert(result[2] == Constants.transactionExtraPaymentId)
        XCTAssert(Array(result.suffix(from: 3)) == paymentIdBytes)
    }
    
    func testDoesNotAddExtraFieldBiggerThan255Bytes() {
        let extra = "4d57b8f1a8c53a8b6de09f37bcc610d27e42e4d791649d63be27516d3a7739632ec396e63f1a8de6d893eada381fbd614fa364934fedc4fd23deb47ad831c0062d8dd58a32c52a337db7cb126612508406fef6d145e44615b261c7fe5d1d5ce6f9ad5e7b63263bee94dafeac52f75913d330c4b57f9e51ee79bc49d03b04c3046981d70c27f650ad4efd1e443dc54207e4de51beca298fa49f987f4f95b6d8f1174a52f2e3206a735e1203e1b0d877034ef6aa23d64f66b4881dccb604a9694e67621d8f457fb06351462626a236ad8645bea6598043a278e6011c43ea7bac758e6f7d8bd984901c837f2c74743a143b36afefeec734b68c68b8a9b4e79a16f6"
        let extraBytes = extra.toBytes
        let field = TransactionExtraField(data: extraBytes, tag: Constants.transactionExtraPaymentId)
        
        let transactionExtra = TransactionExtra(extraFields: [ field ])
        
        let result = transactionExtra.bytes
        
        XCTAssert(result.count == 0)
    }
    
}
