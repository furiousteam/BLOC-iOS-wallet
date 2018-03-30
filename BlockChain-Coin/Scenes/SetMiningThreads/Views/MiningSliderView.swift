//
//  MiningSliderView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MiningSliderView: View {
    let sliderBackgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.minerSliderBg()
        return imageView
    }()
    
    let sliderGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        
        gradient.colors = [ UIColor(hex: 0x00ffff).cgColor,
                            UIColor(hex: 0x00dddd).cgColor,
                            UIColor(hex: 0xe8532c).cgColor,
                            UIColor(hex: 0xe01456).cgColor ]
        
        gradient.locations = [ 0.0, 0.25, 0.5, 1.0 ]
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        return gradient
    }()
    
    let sliderGradientView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        return view
    }()
    
    let sliderView = Slider()

    override func commonInit() {
        super.commonInit()
        
        addSubview(sliderBackgroundView)
        addSubview(sliderGradientView)
        addSubview(sliderView)
        
        sliderGradientView.layer.insertSublayer(sliderGradientLayer, at: 0)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        sliderBackgroundView.snp.makeConstraints({
            $0.height.equalTo(14.0)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        })
        
        sliderGradientView.snp.makeConstraints({
            $0.height.equalTo(4.5)
            $0.leading.trailing.equalToSuperview().inset(5.0)
            $0.centerY.equalToSuperview()
        })
        
        sliderView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sliderGradientLayer.frame = sliderGradientView.bounds
    }
}
