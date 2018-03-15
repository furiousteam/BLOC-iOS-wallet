//
//  ActionButton.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width + 40.0, height: 40.0)
    }
    
    convenience init(title: String) {
        self.init(type: .custom)
        
        setTitle(title, for: .normal)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        setBackgroundImage(R.image.actionButtonBg(), for: .normal)
        tintColor = UIColor(hex: 0x00ffff)
        setTitleColor(UIColor(hex: 0x000029), for: .normal)
        titleLabel?.font = .regular(size: 13.5)
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor(hex: 0x00ffff).cgColor
        layer.shadowRadius = 15.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        
        rasterize()
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: .normal)
        
        rasterize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rasterize()
    }
    
    fileprivate func rasterize() {
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }
    
}
