//
//  ListWalletsRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ListWalletsRoutingLogic {
    func showAddWallet()
    func showWallet(wallet: WalletModel, name: String)
    func goBack()
    func showHome()
    func showImportWalletWithKey()
    func showImportWalletWithQRCode()
}

class ListWalletsRouter: ListWalletsRoutingLogic {
    weak var viewController: UIViewController?
    
    func showAddWallet() {
        let vc = SetWalletPasswordVC(mode: .create)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showWallet(wallet: WalletModel, name: String) {
        let vc = ShowWalletVC(wallet: wallet, name: name)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showImportWalletWithKey() {
        let vc = SetWalletPasswordVC(mode: .restorePrivateKey)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showImportWalletWithQRCode() {
        let vc = SetWalletPasswordVC(mode: .restoreQRCode)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showHome() {
        NotificationCenter.default.post(name: .selectMenuTab, object: nil)
    }
}
