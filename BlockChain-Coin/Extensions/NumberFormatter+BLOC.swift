//
//  NumberFormatter+BLOC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

extension Double {
    enum BLOCCurrencyMode {
        case noCurrency
        case withCurrency
        case withCurrencyAndPrefix
    }
    
    fileprivate static let blocNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 4
        numberFormatter.numberStyle = .none
        numberFormatter.positiveSuffix = " BLOC"
        numberFormatter.locale = Locale.current
        numberFormatter.minimumIntegerDigits = 1
        return numberFormatter
    }()
    
    fileprivate static let blocNumberWithPrefixesFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 4
        numberFormatter.numberStyle = .none
        numberFormatter.positiveSuffix = " BLOC"
        numberFormatter.positivePrefix = "+ "
        numberFormatter.negativePrefix = "- "
        numberFormatter.negativeSuffix = " BLOC"
        numberFormatter.locale = Locale.current
        numberFormatter.minimumIntegerDigits = 1
        return numberFormatter
    }()
    
    fileprivate static let blocWithoutCurrencyNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 4
        numberFormatter.numberStyle = .none
        numberFormatter.currencySymbol = ""
        numberFormatter.locale = Locale.current
        numberFormatter.minimumIntegerDigits = 1
        return numberFormatter
    }()
    
    fileprivate static let blocOtherCurrencyNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .currencyAccounting
        numberFormatter.locale = Locale.current
        numberFormatter.minimumIntegerDigits = 1
        return numberFormatter
    }()
    
    func blocCurrency(mode: BLOCCurrencyMode = .withCurrency) -> String {
        switch mode {
        case .noCurrency:
            return Double.blocWithoutCurrencyNumberFormatter.string(from: NSNumber(value: self)) ?? "0"
        case .withCurrency:
            return Double.blocNumberFormatter.string(from: NSNumber(value: self)) ?? "0 BLOC"
        case .withCurrencyAndPrefix:
            return Double.blocNumberWithPrefixesFormatter.string(from: NSNumber(value: self)) ?? "0 BLOC"
        }
    }
    
    func blocCurrencyWithColor(mode: BLOCCurrencyMode = .withCurrency) -> NSAttributedString {
        switch mode {
        case .noCurrency:
            return NSAttributedString(string: Double.blocWithoutCurrencyNumberFormatter.string(from: NSNumber(value: self)) ?? "0")
        case .withCurrency:
            return NSAttributedString(string: Double.blocNumberFormatter.string(from: NSNumber(value: self)) ?? "0 BLOC")
        case .withCurrencyAndPrefix:
            let negativeAttributes: [NSAttributedStringKey: Any] = [ .foregroundColor: UIColor(hex: 0xff0000) ]
            let positiveAttributes: [NSAttributedStringKey: Any] = [ .foregroundColor: UIColor(hex: 0x00ffff) ]

            let string = Double.blocNumberWithPrefixesFormatter.string(from: NSNumber(value: self)) ?? "0 BLOC"
            
            let attrString = NSMutableAttributedString(string: string)
            
            let positiveRange = (string as NSString).range(of: "+")
            if positiveRange.location != NSNotFound {
                attrString.addAttributes(positiveAttributes, range: positiveRange)
            }

            let negativeRange = (string as NSString).range(of: "-")
            if negativeRange.location != NSNotFound {
                attrString.addAttributes(negativeAttributes, range: negativeRange)
            }

            return attrString
        }
    }
    
    func otherCurrency(code: String) -> String {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.maximumFractionDigits = 8
        numberFormatter.numberStyle = .currencyAccounting
        numberFormatter.locale = Locale.current
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.currencyCode = code

        switch code {
        case "USD":
            numberFormatter.currencySymbol = "$"
        case "EUR":
            numberFormatter.currencySymbol = "€"
        case "BTC":
            numberFormatter.currencySymbol = "Ƀ"
            numberFormatter.maximumFractionDigits = 10
        default:
            break
        }
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "0 \(code)"
    }

}
