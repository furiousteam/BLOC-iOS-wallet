//
//  WalletRPCGetTransactionsResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol WalletRPCGetTransactionsItemModel {
    var blockHash: String { get }
    var transactions: [Transaction] { get }
}

struct WalletRPCGetTransactionsItem: WalletRPCGetTransactionsItemModel, Decodable {
    let blockHash: String
    let transactions: [Transaction]
    
    enum CodingKeys: String, CodingKey {
        case blockHash = "blockHash"
        case transactions = "transactions"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.blockHash = try values.decode(String.self, forKey: .blockHash)
        
        let transactions = try values.decode([Transaction].self, forKey: .transactions)
        
        self.transactions = transactions.flatMap { transaction -> Transaction? in
            if transaction.transfers.isEmpty {
                return nil
            }
            
            return transaction
        }
    }
}

protocol WalletRPCGetTransactionsResponseModel {
    var items: [WalletRPCGetTransactionsItem] { get }
}

struct WalletRPCGetTransactionsResponse: WalletRPCGetTransactionsResponseModel, Decodable {
    let items: [WalletRPCGetTransactionsItem]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let items = try values.decode([WalletRPCGetTransactionsItem].self, forKey: .items)
        
        self.items = items.flatMap { item -> WalletRPCGetTransactionsItem? in
            if item.transactions.isEmpty {
                return nil
            }
            
            return item
        }
    }

}
