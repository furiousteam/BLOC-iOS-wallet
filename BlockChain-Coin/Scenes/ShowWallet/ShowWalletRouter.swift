//
//  ShowWalletRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ShowWalletRoutingLogic {
    func showSettings(wallet: WalletModel)
    func goBack()
}

class ShowWalletRouter: ShowWalletRoutingLogic {
    weak var viewController: UIViewController?
    
    func showSettings(wallet: WalletModel) {
        // TODO: Show wallet settings
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
