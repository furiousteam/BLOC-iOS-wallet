//
//  WalletMemStore.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 26/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

class WalletMemStore: WalletStore {
    static var fakeWallet: Wallet {
        let myAddress = "abLocBPAGpecy5fnBxsGV22SSkJqwNY8gAJL7JQWkZXxbqNRzSHuXNWftSgW8GLWdBWxHYsGhSnS1iGR46adncN4XjMSThpV1RE"
        
        let transferA = Transfer(address: myAddress, amount: 10.0)

        let transactionA = Transaction(hash: "913d36c27ad4aa91ef26b626efe9278723f6b99e0e011b54f3fed99afcb8950e",
                                       blockIndex: 0,
                                       createdAt: Date().addingTimeInterval(-3600),
                                       unlockHeight: 1254,
                                       amount: 10.0,
                                       fee: 0.0001,
                                       extra: "",
                                       paymentId: "",
                                       transfers: [ transferA ])
        
        let transferB = Transfer(address: "abLocsomeoneelse", amount: -5.1)

        let transactionB = Transaction(hash: "913d36c27ad4aa91ef26b626efe9278723f6b99e0e011b54f3fed99afcb8950e",
                                       blockIndex: 0,
                                       createdAt: Date().addingTimeInterval(-72600),
                                       unlockHeight: 0,
                                       amount: -5.1,
                                       fee: 0.0001,
                                       extra: "",
                                       paymentId: "",
                                       transfers: [ transferB ])

        let transferC = Transfer(address: "abLocsomeoneelse", amount: -2.98)
        
        let transactionC = Transaction(hash: "913d36c27ad4aa91ef26b626efe9278723f6b99e0e011b54f3fed99afcb8950e",
                                       blockIndex: 0,
                                       createdAt: Date().addingTimeInterval(-65600),
                                       unlockHeight: 0,
                                       amount: -2.98,
                                       fee: 0.0001,
                                       extra: "",
                                       paymentId: "",
                                       transfers: [ transferC ])
        
        let transferD = Transfer(address: myAddress, amount: 14.6)
        
        let transactionD = Transaction(hash: "913d36c27ad4aa91ef26b626efe9278723f6b99e0e011b54f3fed99afcb8950e",
                                       blockIndex: 0,
                                       createdAt: Date().addingTimeInterval(-129600),
                                       unlockHeight: 0,
                                       amount: 14.6,
                                       fee: 0.0001,
                                       extra: "",
                                       paymentId: "",
                                       transfers: [ transferD ])

        let transferE = Transfer(address: myAddress, amount: 21.2)
        
        let transactionE = Transaction(hash: "913d36c27ad4aa91ef26b626efe9278723f6b99e0e011b54f3fed99afcb8950e",
                                       blockIndex: 0,
                                       createdAt: Date().addingTimeInterval(-159600),
                                       unlockHeight: 0,
                                       amount: 21.2,
                                       fee: 0.0001,
                                       extra: "",
                                       paymentId: "",
                                       transfers: [ transferE ])

        let details = WalletDetails(availableBalance: 631000.0, lockedBalance: 0.0, address: myAddress, transactions: [ transactionA, transactionB, transactionC, transactionD, transactionE ])
        
        let wallet = Wallet(uuid: UUID(),
                            keyPair: KeyPair(seed: try! Seed()),
                            address: myAddress,
                            password: "tests",
                            name: "My Wallet",
                            details: details,
                            createdAt: Date())
        
        return wallet
    }
    
    static var fakeBackupWallet: Wallet {
        let myAddress = "abLocBPAGpecy5fnBxsGV22SSkJqwNY8gAJL7JQWkZXxbqNRzSHuXNWftSgW8GLWdBWxHYsGhSnS1iGR46adncN4XjMSThpV1RE"
        
        let details = WalletDetails(availableBalance: 10000.0, lockedBalance: 0.0, address: myAddress, transactions: [ ])
        
        let wallet = Wallet(uuid: UUID(),
                            keyPair: KeyPair(seed: try! Seed()),
                            address: myAddress,
                            password: "tests",
                            name: "My Backup Wallet",
                            details: details,
                            createdAt: Date())
        
        return wallet
    }
    
    func addWallet(keyPair: KeyPair, uuid: UUID, secretKey: String?, password: String?, address: String?, name: String, details: WalletDetails?, completion: @escaping WalletStoreAddWalletCompletionHandler) {
        // Ignore
    }
    
    func getBalanceAndTransactions(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetBalanceAndTransactionsCompletionHandler) {
        completion(.success(result: WalletMemStore.fakeWallet.details!))
    }
    
    func getAllWalletDetails(wallets: [WalletModel], completion: @escaping WalletStoreGetAllWalletDetailsCompletionHandler) {
        // TODO
    }
    
    func getKeys(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetKeysCompletionHandler) {
        // Ignore
    }
    
    func transfer(wallet: WalletModel, password: String, destination: String, amount: Int64, fee: UInt64, anonymity: UInt64, unlockHeight: UInt64?, paymentId: String?, completion: @escaping WalletStoreTransferCompletionHandler) {
        // Ignore
    }
    
    func remove(wallet: WalletModel) {
        // Ignore
    }
    
    func generateSeed() -> Seed? {
        // Ignore
        return nil
    }
    
    func generateKeyPair(seed: Seed) -> KeyPair? {
        // Ignore
        return nil
    }
    
    func listWallets(completion: @escaping WalletStoreListWalletsCompletionHandler) {
        let wallets = [ WalletMemStore.fakeWallet, WalletMemStore.fakeBackupWallet ]
        
        completion(.success(result: wallets))
    }
    
}
