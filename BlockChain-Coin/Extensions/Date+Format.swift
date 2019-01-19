//
//  Date+Format.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

extension Date {
    fileprivate static let shortTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    fileprivate static let relativeShortTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    fileprivate static let fullTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    static let isoDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
        
    func shortDate() -> String {
        return Date.shortTimeFormatter.string(from: self)
    }
    
    func relativeShortDate() -> String {
        return Date.relativeShortTimeFormatter.string(from: self)
    }
    
    func fullDate() -> String {
        return Date.fullTimeFormatter.string(from: self)
    }
}
