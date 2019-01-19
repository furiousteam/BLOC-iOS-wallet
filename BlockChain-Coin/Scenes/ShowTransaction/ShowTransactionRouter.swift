//  
//  ShowTransactionRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 25/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ShowTransactionRoutingLogic {
    func goBack()
    func showExplorer(blockHash: String, transactionHash: String)
}

class ShowTransactionRouter: Router, ShowTransactionRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showExplorer(blockHash: String, transactionHash: String) {
        UIApplication.shared.open(URL(string: "https://bloc-explorer.com/block/\(blockHash)/\(transactionHash)")!, options: [:], completionHandler: nil)
    }
}

