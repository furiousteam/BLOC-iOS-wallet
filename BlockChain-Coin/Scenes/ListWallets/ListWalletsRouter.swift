//
//  ListWalletsRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ListWalletsRoutingLogic {
    func showAddWallet()
}

class ListWalletsRouter: ListWalletsRoutingLogic {
    weak var viewController: UIViewController?
    
    func showAddWallet() {
        // TODO
    }
}
