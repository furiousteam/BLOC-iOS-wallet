//
//  ShowTransactionFormViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 25/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowTransactionFormViews {
    let orderedViews: [UIView]
    
    let titleView = ShowTransactionTitleView()
    
    let amountView = ShowTransactionContentView()
    
    let dateView = ShowTransactionContentView()
    
    let destinationView = ShowTransactionContentView()
    
    let hashView = ShowTransactionContentView()
    
    let heightAndTransferView = ShowTransactionMultiColumnView()
    
    let feeAndPaymentIDView = ShowTransactionMultiColumnView()
    
    let explorerView = ShowTransactionExplorerView()
    
    init() {
        orderedViews = [ titleView,
                         amountView,
                         dateView,
                         destinationView,
                         hashView,
                         heightAndTransferView,
                         feeAndPaymentIDView,
                         explorerView ]
    }
    
    func attributedString(forAmount amount: Double) -> NSAttributedString {
        let amountAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.regular(size: 15.0), .foregroundColor: UIColor.white ]
        let amountBoldAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.bold(size: 15.0), .foregroundColor: amount < 0.0 ? UIColor(hex: 0xff0000) : UIColor(hex: 0x00ffff) ]
        
        let amountString = amount.blocCurrency(mode: .withCurrencyAndPrefix)
        let string = R.string.localizable.transaction_details_amount(amountString)
        let amountAttrString = NSMutableAttributedString(string: string, attributes: amountAttributes)
        
        let amountRange = (string as NSString).range(of: amountString)
        
        if amountRange.location != NSNotFound {
            amountAttrString.addAttributes(amountBoldAttributes, range: amountRange)
        }
        
        return amountAttrString
    }
    
    func attributedString(titleAndContent: String, content: String) -> NSAttributedString {
        let attributes: [NSAttributedStringKey: Any] = [ .font: UIFont.regular(size: 12.5), .foregroundColor: UIColor.white ]
        let grayAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.regular(size: 12.5), .foregroundColor: UIColor.white.withAlphaComponent(0.75) ]
        
        let attrString = NSMutableAttributedString(string: titleAndContent, attributes: attributes)
        
        let range = (titleAndContent as NSString).range(of: content)
        
        if range.location != NSNotFound {
            attrString.addAttributes(grayAttributes, range: range)
        }
        
        return attrString
    }
    
}
