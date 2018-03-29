//  
//  SetMiningWalletRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol SetMiningWalletRoutingLogic {
    func goBack()
}

class SetMiningWalletRouter: Router, SetMiningWalletRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

