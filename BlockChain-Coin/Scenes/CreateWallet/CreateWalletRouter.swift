//
//  CreateWalletRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol CreateWalletRoutingLogic {
    func showMnemonic(mnemonic: String, address: String)
    func showRestoreWallet()
}

class CreateWalletRouter: CreateWalletRoutingLogic {
    weak var viewController: UIViewController?
    
    func showMnemonic(mnemonic: String, address: String) {
        // TODO
    }
    
    func showRestoreWallet() {
        // TODO
    }
}
