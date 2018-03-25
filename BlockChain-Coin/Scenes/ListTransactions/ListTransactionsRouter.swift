//  
//  ListTransactionsRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ListTransactionsRoutingLogic {
    func showHome()
    func goBack()
    func showTransaction(transaction: ListTransactionItemViewModel)
}

class ListTransactionsRouter: Router, ListTransactionsRoutingLogic {
    weak var viewController: UIViewController?
    
    func showHome() {
        let homeVC = HomeVC()
        viewController?.navigationController?.present(homeVC, animated: true, completion: nil)
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showTransaction(transaction: ListTransactionItemViewModel) {
        let vc = ShowTransactionVC(transaction: transaction)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

