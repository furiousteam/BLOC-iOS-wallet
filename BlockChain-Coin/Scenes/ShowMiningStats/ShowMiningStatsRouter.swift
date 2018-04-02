//  
//  ShowMiningStatsRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ShowMiningStatsRoutingLogic {
    func goBack()
}

class ShowMiningStatsRouter: Router, ShowMiningStatsRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

