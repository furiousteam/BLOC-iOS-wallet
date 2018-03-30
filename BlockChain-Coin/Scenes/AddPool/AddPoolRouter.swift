//  
//  AddPoolRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol AddPoolRoutingLogic {
    func goBack()
}

class AddPoolRouter: Router, AddPoolRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

