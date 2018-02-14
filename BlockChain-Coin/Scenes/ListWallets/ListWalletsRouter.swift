//
//  ListWalletsRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ListWalletsRoutingLogic {
    func showAddWallet()
    func showWallet(wallet: WalletModel)
    func goBack()
}

class ListWalletsRouter: ListWalletsRoutingLogic {
    weak var viewController: UIViewController?
    
    func showAddWallet() {
        let vc = CreateWalletVC()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showWallet(wallet: WalletModel) {
        let vc = ShowWalletVC(wallet: wallet)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
