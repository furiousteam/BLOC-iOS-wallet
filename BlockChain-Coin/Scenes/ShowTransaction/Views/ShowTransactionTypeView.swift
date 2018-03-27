//
//  ShowTransactionTypeView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 25/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowTransactionTypeView: View {

    override var intrinsicContentSize: CGSize {
        let size = stackView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
        return CGSize(width: size.width, height: size.height)
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 4.0
        return view
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.layoutMargins = UIEdgeInsets(top: 2.5, left: 2.5, bottom: 2.5, right: 2.5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor(hex: 0x000029)
        return label
    }()
    
    let typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hex: 0x000029)
        return imageView
    }()

    override func commonInit() {
        super.commonInit()
        
        addSubview(containerView)
        
        containerView.addSubview(stackView)
        
        [ titleLabel, typeImageView ].forEach(stackView.addArrangedSubview)
        
        layer.masksToBounds = false
        layer.shadowRadius = 15.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        containerView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        typeImageView.snp.makeConstraints({
            $0.width.equalTo(10)
            $0.height.equalTo(8.5)
        })
    }
    
    func configure(type: TransactionType) {
        titleLabel.text = type.text
        titleLabel.textColor = type == .received ? UIColor(hex: 0x000029) : UIColor.white
        typeImageView.tintColor = type == .received ? UIColor(hex: 0x000029) : UIColor.white
        typeImageView.image = type.smallImage
        containerView.backgroundColor = type.color
        layer.shadowColor = type.color.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.layer.rasterizationScale = UIScreen.main.scale
        containerView.layer.shouldRasterize = true
        
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }

}
