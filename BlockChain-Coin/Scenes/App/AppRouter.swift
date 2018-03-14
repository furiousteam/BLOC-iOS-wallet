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
        guard let window = window else { return }

        let homeVC = HomeVC()
        
        window.rootViewController?.present(homeVC, animated: false, completion: nil)
    }
    
    func showApp() {
        guard let window = window else { return }
        
        window.rootViewController = TabBarVC()
        window.makeKeyAndVisible()
    }
}

