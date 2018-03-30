//
//  AppDelegate.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var app: AppController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        app = AppController()
        
        Fabric.with([Crashlytics.self])
        
        clearDataOnFirstLaunch()
        
        return true
    }

    func clearDataOnFirstLaunch() {
        let userDefaults = UserDefaults.standard
                
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            
            let _ = KeychainWrapper.standard.removeAllKeys()
            KeychainWrapper.standard.removeObject(forKey: "wallets")
            
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize()
            
            return
        }
    }
}

