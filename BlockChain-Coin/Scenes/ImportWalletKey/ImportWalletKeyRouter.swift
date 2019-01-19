//  
//  ImportWalletKeyRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ImportWalletKeyRoutingLogic {
    func goBack()
}

class ImportWalletKeyRouter: Router, ImportWalletKeyRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}

