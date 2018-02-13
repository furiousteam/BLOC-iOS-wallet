//
//  MineRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol MineRoutingLogic {
    func showWallets()
}

class MineRouter: MineRoutingLogic {
    weak var viewController: UIViewController?
    
    func showWallets() {
        let vc = ListWalletsVC()
        let navVC = UINavigationController(rootViewController: vc)
        viewController?.present(navVC, animated: true, completion: nil)
    }
}
