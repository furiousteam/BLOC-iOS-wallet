//
//  MiningSwitchView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 28/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MiningSwitchView: View {

    let offImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.switchBgOff()
        imageView.contentMode = .left
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let onImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.switchBgOn()
        imageView.contentMode = .left
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.switchButtonBg()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let onButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.switchButtonOn()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.alpha = 0.0
        return imageView
    }()
    
    let offButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.switchButtonOff()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    var isOn: Bool = false {
        didSet {
            set(on: isOn)
        }
    }
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(offImageView)
        addSubview(onImageView)
        addSubview(buttonImageView)
        addSubview(offButtonImageView)
        addSubview(onButtonImageView)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        offImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        onImageView.snp.makeConstraints({
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(-110)
        })
        
        buttonImageView.snp.makeConstraints({
            $0.width.height.equalTo(52.0)
            $0.leading.equalTo(0.0)
            $0.centerY.equalToSuperview()
        })
        
        onButtonImageView.snp.makeConstraints({
            $0.width.height.equalTo(buttonImageView)
            $0.leading.equalTo(buttonImageView)
            $0.centerY.equalTo(buttonImageView)
        })

        offButtonImageView.snp.makeConstraints({
            $0.width.height.equalTo(buttonImageView)
            $0.leading.equalTo(buttonImageView)
            $0.centerY.equalTo(buttonImageView)
        })
    }
    
    private func set(on: Bool, animated: Bool = true) {        
        UIView.animate(withDuration: (animated ? 0.3 : 0.0)) {
            self.onButtonImageView.alpha = on ? 1.0 : 0.0
            self.offButtonImageView.alpha = on ? 0.0 : 1.0
            
            if on {
                self.onImageView.snp.updateConstraints({
                    $0.trailing.equalTo(0.0)
                })
                
                self.buttonImageView.snp.updateConstraints({
                    $0.leading.equalTo(self.offImageView.bounds.width - 52.0)
                })
            } else {
                self.onImageView.snp.updateConstraints({
                    $0.trailing.equalTo(-self.offImageView.bounds.width)
                })
                
                self.buttonImageView.snp.updateConstraints({
                    $0.leading.equalTo(0.0)
                })
            }
            
            self.layoutSubviews()
        }
    }
    
}
