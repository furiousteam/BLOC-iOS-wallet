//  
//  ImportWalletKeyRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ImportWalletKeyRoutingLogic {
    func goBack()
    func showWalletSetPassword(wallet: WalletModel)
}

class ImportWalletKeyRouter: Router, ImportWalletKeyRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showWalletSetPassword(wallet: WalletModel) {
        // TODO
    }
}

