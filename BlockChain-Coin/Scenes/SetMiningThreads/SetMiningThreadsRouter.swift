//  
//  SetMiningThreadsRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol SetMiningThreadsRoutingLogic {
    func goBack()
}

class SetMiningThreadsRouter: Router, SetMiningThreadsRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

