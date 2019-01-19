//  
//  ListTransactionsRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
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
        NotificationCenter.default.post(name: .selectMenuTab, object: nil)
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showTransaction(transaction: ListTransactionItemViewModel) {
        let vc = ShowTransactionVC(transaction: transaction)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

