//
//  WalletAPITransferResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol WalletAPITransferResponseModel {
    var transactionHash: String { get }
}

class WalletAPITransferResponse: WalletAPITransferResponseModel, Decodable {
    enum CodingKeys: String, CodingKey {
        case transactionHash = "transactionHash"
    }
    
    let transactionHash: String
    
    init(transactionHash: String) {
        self.transactionHash = transactionHash
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        transactionHash = try values.decode(String.self, forKey: .transactionHash)
    }
    
}
