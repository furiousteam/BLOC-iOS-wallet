//  
//  DeleteWalletRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 04/04/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol DeleteWalletRoutingLogic {
    func goBack()
    func goToWalletsList()
}

class DeleteWalletRouter: Router, DeleteWalletRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        self.viewController?.navigationController?.popViewController(animated: true)
    }
    
    func goToWalletsList() {
        (self.viewController?.presentingViewController as? TabBarVC)?.walletsVC.navigationController?.popToRootViewController(animated: true)

        self.viewController?.dismiss(animated: true, completion: nil)
    }
}

