//  
//  ConfirmTransactionRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ConfirmTransactionRoutingLogic {
    func goBack()
}

class ConfirmTransactionRouter: Router, ConfirmTransactionRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

