//  
//  ImportWalletQRCodeRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 17/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ImportWalletQRCodeRoutingLogic {
    func goBack()
}

class ImportWalletQRCodeRouter: Router, ImportWalletQRCodeRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        (self.viewController?.presentingViewController as? TabBarVC)?.walletsVC.navigationController?.popToRootViewController(animated: true)
        viewController?.dismiss(animated: true, completion: nil)
    }
}

