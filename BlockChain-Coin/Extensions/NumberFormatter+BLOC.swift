//
//  NumberFormatter+BLOC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

extension Double {
    fileprivate static let blocNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.currencySymbol = "BLOC"
        numberFormatter.locale = Locale.current
        return numberFormatter
    }()
    
    func blocCurrency() -> String {
        return Double.blocNumberFormatter.string(from: NSNumber(value: self)) ?? "0 BLOC"
    }

}
