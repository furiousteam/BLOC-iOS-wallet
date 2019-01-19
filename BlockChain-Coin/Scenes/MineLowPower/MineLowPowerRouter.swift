//  
//  MineLowPowerRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol MineLowPowerRoutingLogic {
    func goBack()
}

class MineLowPowerRouter: Router, MineLowPowerRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

