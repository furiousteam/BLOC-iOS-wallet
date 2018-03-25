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
    func showTransactionsHistory(wallet: WalletModel)
    func showTransaction(transaction: ListTransactionItemViewModel)
}

class ShowWalletRouter: ShowWalletRoutingLogic {
    weak var viewController: UIViewController?
    
    func showSettings(wallet: WalletModel) {
        // TODO: Show wallet settings
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showTransactionsHistory(wallet: WalletModel) {
        let vc = ListTransactionsVC(wallets: [ wallet ])
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTransaction(transaction: ListTransactionItemViewModel) {
        let vc = ShowTransactionVC(transaction: transaction)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
