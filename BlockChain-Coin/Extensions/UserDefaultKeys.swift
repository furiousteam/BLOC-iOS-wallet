//
//  UserDefaultKeys.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

enum UserDefaultsKey: String {
    case environment = "environment"
    case defaultCurrency = "defaultCurrency"
}

extension UserDefaults {
    
    var environment: Environment? {
        set {
            setValue(newValue?.rawValue ?? Environment.production.rawValue, forKey: UserDefaultsKey.environment.rawValue)
        }
        get {
            guard let value = string(forKey: UserDefaultsKey.environment.rawValue) else { return .production }
            
            return Environment(rawValue: value)
        }
    }
    
    var defaultCurrency: String? {
        set {
            setValue(newValue, forKey: UserDefaultsKey.defaultCurrency.rawValue)
        }
        get {
            guard let value = string(forKey: UserDefaultsKey.defaultCurrency.rawValue) else { return "USD" }
            
            return value
        }
    }
}
