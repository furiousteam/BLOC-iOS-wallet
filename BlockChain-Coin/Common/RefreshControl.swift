//
//  RefreshControl.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 24/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class RefreshControl : UIRefreshControl {
    
    convenience init(target: AnyObject?, action: Selector) {
        self.init()
        
        self.addTarget(target, action: action, for: .valueChanged)
    }
    
}
