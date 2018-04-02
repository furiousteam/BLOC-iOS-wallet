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
    func showWalletSettings(selectedWallet: WalletModel)
    func showThreadsSettings(threads: UInt)
    func showPoolSettings(pool: MiningPoolModel)
    func showStats(settings: MiningSettingsModel)
}

class MineRouter: MineRoutingLogic {
    weak var viewController: UIViewController?
    
    func showHome() {
        let homeVC = HomeVC()
        viewController?.navigationController?.present(homeVC, animated: true, completion: nil)
    }
    
    func showWalletSettings(selectedWallet: WalletModel) {
        let vc = SetMiningWalletVC(selectedWallet: selectedWallet)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showThreadsSettings(threads: UInt) {
        let vc = SetMiningThreadsVC(threads: threads)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPoolSettings(pool: MiningPoolModel) {
        let vc = ListPoolsVC(selectedPool: pool)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showStats(settings: MiningSettingsModel) {
        let vc = ShowMiningStatsVC(settings: settings)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
