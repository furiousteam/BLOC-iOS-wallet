//
//  Bundle+Keys.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

enum BundleKey: String {
    case environment = "BLOCEnvironment"
}

extension Bundle {
    func string(forKey key: BundleKey) -> String {
        return (self.infoDictionary?[key.rawValue] as? String) ?? ""
    }
}
