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
    func showWalletKeys(wallet: WalletModel)
}

class SetWalletPasswordRouter: Router, SetWalletPasswordRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showWalletKeys(wallet: WalletModel) {
        let walletKeysVC = ExportWalletKeysVC(wallet: wallet, mode: .creation)
        
        viewController?.navigationController?.pushViewController(walletKeysVC, animated: true)
    }
}

