//
//  Reusable.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol Reusable {
    
    static func reuseIdentifier() -> String
    static func className() -> String
}

extension Reusable where Self: AnyObject {
    
    static func reuseIdentifier() -> String {
        return self.className()
    }
    
    static func className() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
