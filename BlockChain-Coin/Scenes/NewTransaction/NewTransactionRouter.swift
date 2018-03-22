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
}

class NewTransactionRouter: Router, NewTransactionRoutingLogic {
    weak var viewController: UIViewController?
    
    func showHome() {
        let homeVC = HomeVC()
        viewController?.navigationController?.present(homeVC, animated: true, completion: nil)
    }
}

