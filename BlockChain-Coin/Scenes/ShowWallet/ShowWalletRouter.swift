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
    func showCoinGecko()
}

class ShowWalletRouter: ShowWalletRoutingLogic {
    weak var viewController: UIViewController?
    
    func showSettings(wallet: WalletModel) {
        let vc = WalletSettingsVC(wallet: wallet)
        viewController?.present(NavigationController(rootViewController: vc), animated: true, completion: nil)
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
    
    func showCoinGecko() {
        UIApplication.shared.open(URL(string: "https://www.coingecko.com/en/coins/bloc-money")!, options: [:], completionHandler: nil)
    }
}
