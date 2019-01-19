//
//  MiningBooterView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 28/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class MiningBooterView: View {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0.0
        return stackView
    }()
    
    let offLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 12.5)
        label.numberOfLines = 1
        label.textColor = UIColor(hex: 0xff0000)
        label.text = R.string.localizable.mining_off().localizedUppercase
        return label
    }()
    
    let offImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = false
        imageView.image = R.image.miningDotOffActive()
        return imageView
    }()
    
    let onLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 12.5)
        label.numberOfLines = 1
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.text = R.string.localizable.mining_on().localizedUppercase
        return label
    }()
    
    let onImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = false
        imageView.image = R.image.miningDotInactive()
        return imageView
    }()
    
    override func commonInit() {
        super.commonInit()
        
        backgroundColor = .clear
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        offImageView.snp.makeConstraints({
            $0.width.equalTo(20.0)
        })
        
        onImageView.snp.makeConstraints({
            $0.width.equalTo(20.0)
        })
        
        [ offLabel, offImageView, SpacerView(width: 110.0), onImageView, onLabel ].forEach(stackView.addArrangedSubview)
    }
    
    func configure(isOn: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.onLabel.textColor = isOn ? UIColor(hex: 0x00ffff) : UIColor.white.withAlphaComponent(0.5)
            self.offLabel.textColor = isOn ? UIColor.white.withAlphaComponent(0.5) : UIColor(hex: 0xff0000)
        }
         
        UIView.transition(with: offImageView, duration: 0.3, options: [ .transitionCrossDissolve ], animations: {
            self.offImageView.image = isOn ? R.image.miningDotInactive() : R.image.miningDotOffActive()
        }, completion: nil)
         
        UIView.transition(with: onImageView, duration: 0.3, options: [ .transitionCrossDissolve ], animations: {
            self.onImageView.image = isOn ? R.image.miningDotOnActive() : R.image.miningDotInactive()
        }, completion: nil)
    }

}
