//
//  SmallButton.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class SmallButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width + 20.0, height: 40.0)
    }
    
    convenience init(title: String) {
        self.init(type: .system)
        
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
        setBackgroundImage(UIImage.withColor(UIColor(hex: 0x001b45)), for: .normal)
        setBackgroundImage(UIImage.withColor(UIColor(hex: 0x0046ff)), for: .selected)
        setBackgroundImage(UIImage.withColor(UIColor(hex: 0x0046ff)), for: .highlighted)

        tintColor = UIColor.white.withAlphaComponent(0.5)
        setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        setTitleColor(.white, for: .selected)
        titleLabel?.font = .regular(size: 10.0)
        
        layer.masksToBounds = true
        layer.cornerRadius = 4.0
        
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

