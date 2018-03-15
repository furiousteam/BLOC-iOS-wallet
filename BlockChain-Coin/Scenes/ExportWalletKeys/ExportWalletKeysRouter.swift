//  
//  ExportWalletKeysRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ExportWalletKeysRoutingLogic {
    func showPrintPreview()
    func goToWallet(wallet: WalletModel)
}

class ExportWalletKeysRouter: Router, ExportWalletKeysRoutingLogic {
    weak var viewController: UIViewController?
    
    func showPrintPreview() {
        // TODO: Show print UI
    }
    
    func goToWallet(wallet: WalletModel) {
        // TODO: Show wallet
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}

