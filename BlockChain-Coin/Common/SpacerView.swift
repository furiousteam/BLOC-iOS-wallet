//
//  SpacerView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class SpacerView: View {
    
    var height: CGFloat?
    var width: CGFloat?

    override var intrinsicContentSize: CGSize {
        if let height = height {
            return CGSize(width: super.intrinsicContentSize.width, height: height)
        } else if let width = width {
            return CGSize(width: width, height: super.intrinsicContentSize.height)
        }
        
        return super.intrinsicContentSize
    }
    
    init(height: CGFloat) {
        super.init()
        
        self.height = height
    }
    
    init(width: CGFloat) {
        super.init()
        
        self.width = width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
