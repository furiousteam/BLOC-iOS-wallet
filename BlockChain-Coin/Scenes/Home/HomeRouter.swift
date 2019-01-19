//  
//  HomeRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol HomeRoutingLogic {
    func showWallet()
    func showSend()
    func showTransactions()
    func showAbout()
    func showNews()
}

class HomeRouter: Router, HomeRoutingLogic {
    weak var viewController: UIViewController?
    
    func showWallet() {
        NotificationCenter.default.post(name: .selectWalletTab, object: nil)
        
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showNews() {
        NotificationCenter.default.post(name: .selectNewsTab, object: nil)

        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showSend() {
        NotificationCenter.default.post(name: .selectSendTab, object: nil)
        
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showTransactions() {
        NotificationCenter.default.post(name: .selectTransactionsTab, object: nil)

        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showAbout() {
        let aboutVC = AboutVC()
        
        viewController?.present(NavigationController(rootViewController: aboutVC), animated: true, completion: nil)
    }
}

