//
//  MineRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol MineRoutingLogic {
    func showHome()
}

class MineRouter: MineRoutingLogic {
    weak var viewController: UIViewController?
    
    func showHome() {
        let homeVC = HomeVC()
        viewController?.navigationController?.present(homeVC, animated: true, completion: nil)
    }
}
