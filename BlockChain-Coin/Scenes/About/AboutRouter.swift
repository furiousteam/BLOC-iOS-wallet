//  
//  AboutRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol AboutRoutingLogic {
    func goBack()
}

class AboutRouter: Router, AboutRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

