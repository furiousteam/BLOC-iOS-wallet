//
//  NavigationController.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        NavigationController.configureNavigationBarApperance()
        
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        NavigationController.configureNavigationBarApperance()
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        NavigationController.configureNavigationBarApperance()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // Apperance setup is done here for playground compatiblity
    fileprivate static func configureNavigationBarApperance() {
        let navigationBar = UINavigationBar.appearance(whenContainedInInstancesOf: [ NavigationController.self ])
        navigationBar.tintColor = .trx_black
        
        navigationBar.titleTextAttributes = [ .font: UIFont.bold(size: 15.0),
                                              .foregroundColor: UIColor.trx_black ]
        
        let barButtonItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [ NavigationController.self ])
        
        let barButtonItemAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.bold(size: 17.5) ]
        
        barButtonItem.setTitleTextAttributes(barButtonItemAttributes, for: .normal)
        barButtonItem.setTitleTextAttributes(barButtonItemAttributes, for: .highlighted)
        barButtonItem.setTitleTextAttributes(barButtonItemAttributes, for: .selected)
    }
    
}
