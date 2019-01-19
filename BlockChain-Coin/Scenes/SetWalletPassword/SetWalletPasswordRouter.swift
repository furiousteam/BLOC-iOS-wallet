//  
//  SetWalletPasswordRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol SetWalletPasswordRoutingLogic {
    func goBack()
    func showWalletKeys(wallet: WalletModel)
    func showImportWalletWithKey(password: String, name: String)
    func showImportWalletWithQRCode(password: String, name: String)
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
    
    func showImportWalletWithKey(password: String, name: String) {
        let vc = ImportWalletKeyVC(password: password, name: name)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showImportWalletWithQRCode(password: String, name: String) {
        let vc = ImportWalletQRCodeVC(password: password, name: name)
        
        viewController?.present(vc, animated: true, completion: nil)
    }
}

