//  
//  ConfirmTransactionRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ConfirmTransactionRoutingLogic {
    func goBack()
    func showResult(error: String?)
}

class ConfirmTransactionRouter: Router, ConfirmTransactionRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showResult(error: String?) {
        let result: TransactionResultVC.Result = {
            if let error = error {
                return .error(error: error)
            }
            
            return .success
        }()
        
        let vc = TransactionResultVC(result: result)
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

