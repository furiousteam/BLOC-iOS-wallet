//  
//  TransactionResultRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 23/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol TransactionResultRoutingLogic {
    func goBack(result: TransactionResultVC.Result)
}

class TransactionResultRouter: Router, TransactionResultRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack(result: TransactionResultVC.Result) {
        switch result {
        case .success:
            viewController?.navigationController?.popToRootViewController(animated: true)
        case .error:
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}

