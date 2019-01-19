//
//  WalletSettingsCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class WalletSettingsCell: TableViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10.0
        stackView.layoutMargins = UIEdgeInsets(top: 15.0, left: 20.0, bottom: 15.0, right: 20.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.numberOfLines = 0
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        return label
    }()
    
    let accessoryImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.rightArrow())
        imageView.tintColor = UIColor(hex: 0x00ffff)
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()
    
    override func commonInit() {
        super.commonInit()
        
        contentView.backgroundColor = .clear
        backgroundColor = contentView.backgroundColor
        
        contentView.addSubview(separatorView)
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ leftImageView, textStackView, accessoryImageView ].forEach(stackView.addArrangedSubview)
        
        [ topLabel, bottomLabel ].forEach(textStackView.addArrangedSubview)
        
        accessoryImageView.snp.makeConstraints({
            $0.height.equalTo(8.5)
            $0.width.equalTo(20.5)
        })
        
        separatorView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.backgroundColor = selected ? UIColor(hex: 0x121f46) : .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.backgroundColor = highlighted ? UIColor(hex: 0x121f46) : .clear
    }
    
    func configure(image: UIImage, title: String) {
        leftImageView.image = image
        topLabel.text = title
    }

}
