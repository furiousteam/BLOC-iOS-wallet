//
//  String+Validation.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

extension String {
    
    func isValidURL() -> Bool {
        if let url = URL(string: self), UIApplication.shared.canOpenURL(url) {
            return true
        }
        
        return false
    }
    
}
