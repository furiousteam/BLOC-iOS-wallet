//
//  BlockChain_CoinUITests.swift
//  BlockChain-CoinUITests
//
//  Created by Maxime Bornemann on 26/04/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import XCTest

class BlockChain_CoinUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchEnvironment = [ "UITests": "true" ]
        setupSnapshot(app)
        app.launch()
    }
    
    func testListWallets() {
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["WALLET"]/*[[".cells.staticTexts[\"WALLET\"]",".staticTexts[\"WALLET\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("01ListWallets")
    }
    
    func testWalletDetails() {
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["WALLET"]/*[[".cells.staticTexts[\"WALLET\"]",".staticTexts[\"WALLET\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["My Wallet"]/*[[".cells.staticTexts[\"My Wallet\"]",".staticTexts[\"My Wallet\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("02WalletDetails")
    }
    
    func testNewTransation() {
        let app = XCUIApplication()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["SEND"]/*[[".cells.staticTexts[\"SEND\"]",".staticTexts[\"SEND\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.scrollViews.otherElements.textFields["0"].tap()
        app.scrollViews.otherElements.textFields["0"].typeText("10")
        app.scrollViews.otherElements.textViews["Recipient address"].tap()
        app.scrollViews.otherElements.textViews["Recipient address"].typeText("abLocBPAGpecy5fnBxsGV22SSkJqwNY8gAJL7JQWkZXxbqNRzSHuXNWftSgW8GLWdBWxHYsGhSnS1iGR46adncN4XjMSThpV1RE")
        app.scrollViews.otherElements.collectionViews/*@START_MENU_TOKEN@*/.buttons["My Wallet"]/*[[".cells.buttons[\"My Wallet\"]",".buttons[\"My Wallet\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
     
        let firstKey = XCUIApplication().keys.element(boundBy: 0)
     
        if firstKey.exists {
            app.typeText("\n")
        }
     
        snapshot("04WalletDetails")
    }

    func testTransactionDetails() {
        let tablesQuery = XCUIApplication().tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["WALLET"]/*[[".cells.staticTexts[\"WALLET\"]",".staticTexts[\"WALLET\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["My Wallet"]/*[[".cells.staticTexts[\"My Wallet\"]",".staticTexts[\"My Wallet\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["+ 10 BLOC"]/*[[".cells.staticTexts[\"+ 10 BLOC\"]",".staticTexts[\"+ 10 BLOC\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("05TransactionDetails")
    }
}
