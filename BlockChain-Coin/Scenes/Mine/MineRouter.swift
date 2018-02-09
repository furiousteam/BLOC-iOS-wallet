//
//  MineRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol MineRoutingLogic {
    func showWallet(currentAddress: String, delegate: SetWalletDelegate?)
}

class MineRouter: MineRoutingLogic {
    weak var viewController: UIViewController?
    
    func showWallet(currentAddress: String, delegate: SetWalletDelegate?) {
        let vc = SetWalletVC(wallet: currentAddress, delegate: delegate)
        let navVC = UINavigationController(rootViewController: vc)
        viewController?.present(navVC, animated: true, completion: nil)
    }
}
