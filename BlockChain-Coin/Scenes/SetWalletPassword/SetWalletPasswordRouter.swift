//  
//  SetWalletPasswordRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol SetWalletPasswordRoutingLogic {
    func goBack()
    func showWallet(address: String)
}

class SetWalletPasswordRouter: Router, SetWalletPasswordRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showWallet(address: String) {
        // TODO: Show wallet VC
        log.info("Showing wallet infos for \(address)")
    }
}

