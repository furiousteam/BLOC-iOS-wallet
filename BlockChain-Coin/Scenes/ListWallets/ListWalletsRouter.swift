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
    func showHome()
    func showImportWalletWithKey()
    func showImportWalletWithQRCode()
}

class ListWalletsRouter: ListWalletsRoutingLogic {
    weak var viewController: UIViewController?
    
    func showAddWallet() {
        let vc = SetWalletPasswordVC()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showWallet(wallet: WalletModel) {
        let vc = ShowWalletVC(wallet: wallet)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showImportWalletWithKey() {
        let vc = ImportWalletKeyVC()
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showImportWalletWithQRCode() {
        // TODO: QR Code import
        let vc = ImportWalletKeyVC()
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showHome() {
        let homeVC = HomeVC()
        viewController?.navigationController?.present(homeVC, animated: true, completion: nil)
    }
}
