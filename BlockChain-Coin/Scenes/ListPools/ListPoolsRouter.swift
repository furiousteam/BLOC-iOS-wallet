//  
//  ListPoolsRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ListPoolsRoutingLogic {
    func goBack()
    func showAddPool()
}

class ListPoolsRouter: Router, ListPoolsRoutingLogic {
    weak var viewController: UIViewController?
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showAddPool() {
        let vc = AddPoolVC()
        viewController?.present(NavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

