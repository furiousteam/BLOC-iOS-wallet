//
//  Environment.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

enum Environment: String {
    enum LogLevel: Int {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4
    }
    
    case development = "Development"
    case production = "Production"
    case mock = "Mock"
    
    // The environment defined in Info.plist
    static var bundleEnvironment: Environment? {
        return Environment(rawValue: Bundle.main.string(forKey: .environment))
    }
    
    // The environment defined in the user defaults
    static var settingsEnvironment: Environment? {
        return Environment(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.environment.rawValue) ?? "")
    }
    
    static var current: Environment {
        return UserDefaults.standard.environment ?? .production
    }
    
    var logLevel: LogLevel {
        switch self {
        case .development, .mock:
            return .verbose
        case .production:
            return .verbose
        }
    }
    
    var baseURL: URL {
        switch self {
        case .mock:
            return URL(string: "http://blockchaincoin.local/api/v1")!
        case .development:
            return URL(string: "http://dev.blockchain.coin/api/v1")!
        case .production:
            return URL(string: "http://blockchain.coin/api/v1")!
        }
    }
}
