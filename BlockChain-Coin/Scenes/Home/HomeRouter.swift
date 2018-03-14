//  
//  HomeRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol HomeRoutingLogic {
    func showWallet()
    func showMining()
    func showSend()
    func showTransactions()
    func showAbout()
}

class HomeRouter: Router, HomeRoutingLogic {
    weak var viewController: UIViewController?
    
    func showWallet() {
        // TODO: Show right tab, show wallet setup if needed
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showMining() {
        // TODO: Show right tab, show wallet setup if needed
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showSend() {
        // TODO: Show right tab, show wallet setup if needed
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showTransactions() {
        // TODO: Show right tab, show wallet setup if needed
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showAbout() {
        // TODO: Show right tab, show wallet setup if needed
        viewController?.dismiss(animated: true, completion: nil)
    }
}

