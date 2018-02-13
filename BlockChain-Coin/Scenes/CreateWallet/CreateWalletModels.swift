//
//  CreateWalletModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct CreateWalletViewModel {
    enum State {
        case creating
        case created(mnemonic: String, address: String)
        case error(String)
    }
    
    let state: State
}
