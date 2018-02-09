//
//  UIColor+Hex.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 09/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 08) / 255.0
        let b = CGFloat((hex & 0x0000FF) >> 00) / 255.0
        
        self.init(red:r, green:g, blue:b, alpha:alpha)
    }
    
    public convenience init(hex8: UInt32) {
        let divisor = CGFloat(255)
        let a = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
        let r = CGFloat((hex8 & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex8 & 0x00FF00) >> 08) / 255.0
        let b = CGFloat((hex8 & 0x0000FF) >> 00) / 255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}
