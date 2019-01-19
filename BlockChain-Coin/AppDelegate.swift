//
//  AppDelegate.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var app: AppController!
    
    var defaultBrightness: CGFloat = UIScreen.main.brightness

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        app = AppController()
        
        Fabric.with([Crashlytics.self])
        
        clearDataOnFirstLaunch()
        
        NotificationCenter.default.addObserver(forName: .restoreBrightness, object: nil, queue: nil, using: handleRestoreBrightness)
        NotificationCenter.default.addObserver(forName: .reduceBrightness, object: nil, queue: nil, using: handleReduceBrightness)
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIScreen.main.brightness = defaultBrightness
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        defaultBrightness = UIScreen.main.brightness
        
        NotificationCenter.default.post(name: .playMiningVideo, object: nil)
    }
    
    // MARK: - Setup

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
    
    // MARK: - Brightness handling
    
    @objc func handleRestoreBrightness(notification: Notification) {
        UIScreen.main.brightness = defaultBrightness
    }
    
    @objc func handleReduceBrightness(notification: Notification) {
        UIScreen.main.brightness = 0.01
    }
}

