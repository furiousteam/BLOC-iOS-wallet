//
//  FormToolbar.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class FormToolbar: UIToolbar {
    
    var responders = [UIResponder]()
    
    var previousButton: UIBarButtonItem?
    var nextButton: UIBarButtonItem?
    var arrowsMargin: UIBarButtonItem!
    var flex: UIBarButtonItem!
    var leftMargin: UIBarButtonItem!
    var okButton: UIBarButtonItem?
    var rightMargin: UIBarButtonItem!
    
    fileprivate var activeResponder: UIResponder? {
        return responders.filter { $0.isFirstResponder }.first
    }
    
    init() {
        super.init(frame: .zero)
        
        previousButton = UIBarButtonItem(image: R.image.topArrow(), style: .plain, target: self, action: #selector(previousTapped))
        previousButton?.tintColor = UIColor(hex: 0x000025)
        
        nextButton = UIBarButtonItem(image: R.image.bottomArrow(), style: .plain, target: self, action: #selector(nextTapped))
        nextButton?.tintColor = UIColor(hex: 0x000025)
        
        okButton = UIBarButtonItem(title: R.string.localizable.common_ok(), style: .plain, target: self, action: #selector(okTapped))
        okButton?.tintColor = UIColor(hex: 0x000025)
        
        arrowsMargin = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        arrowsMargin.width = 15.0
        
        flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        leftMargin = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        leftMargin.width = 5.0
        
        rightMargin = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        rightMargin.width = 5.0
        
        sizeToFit()
        
        items = [ previousButton!, arrowsMargin, nextButton!, flex, okButton!, rightMargin! ]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateArrows() {
        if let activeResponder = activeResponder, let index = responders.index(of: activeResponder) {
            previousButton?.isEnabled = (index != 0)
            nextButton?.isEnabled = (index != responders.count - 1)
        }
    }
    
    @objc func previousTapped() {
        if let activeResponder = activeResponder, let index = responders.index(of: activeResponder) {
            if (index - 1) >= responders.startIndex {
                responders[(index - 1)].becomeFirstResponder()
            }
        }
    }
    
    @objc func nextTapped() {
        if let activeResponder = activeResponder, let index = responders.index(of: activeResponder) {
            if (index + 1) < responders.endIndex {
                responders[(index + 1)].becomeFirstResponder()
            }
        }
        else {
            responders.first?.becomeFirstResponder()
        }
    }
    
    @objc func okTapped() {
        activeResponder?.resignFirstResponder()
    }
    
}
