//  
//  NewTransactionRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 21/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol NewTransactionRoutingLogic {
    func showHome()
    func showConfirmTransaction(form: NewTransactionForm)
}

class NewTransactionRouter: Router, NewTransactionRoutingLogic {
    weak var viewController: UIViewController?
    
    func showHome() {
        NotificationCenter.default.post(name: .selectMenuTab, object: nil)
    }
    
    func showConfirmTransaction(form: NewTransactionForm) {
        let vc = ConfirmTransactionVC(form: form)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

