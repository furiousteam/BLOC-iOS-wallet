//  
//  AppRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol AppRoutingLogic {
    func showHome()
    func showApp()
}

class AppRouter: Router, AppRoutingLogic {
    weak var window: UIWindow?

    func showHome() {
        NotificationCenter.default.post(name: .selectMenuTab, object: nil)
    }
    
    func showApp() {
        guard let window = window else { return }
        
        window.rootViewController = TabBarVC()
        window.makeKeyAndVisible()
    }
}

