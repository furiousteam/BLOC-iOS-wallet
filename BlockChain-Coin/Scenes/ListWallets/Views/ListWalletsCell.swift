//
//  ListWalletsCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ListWalletsCell: TableViewCell {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15.0
        stackView.layoutMargins = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10.0, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.2)
        return label
    }()
    
    let accessoryImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.accessory())
        imageView.tintColor = UIColor.black.withAlphaComponent(0.2)
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xEEEEEE)
        return view
    }()
    
    override func commonInit() {
        super.commonInit()
        
        contentView.addSubview(separatorView)
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ textStackView, accessoryImageView ].forEach(stackView.addArrangedSubview)
        
        [ addressLabel, createdAtLabel ].forEach(textStackView.addArrangedSubview)
        
        accessoryImageView.snp.makeConstraints({
            $0.height.equalTo(11.0)
            $0.width.equalTo(6.2)
        })
        
        separatorView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }
    
    func configure(address: String, createdAt: Date) {
        addressLabel.text = address
        createdAtLabel.text = createdAt.shortDate()
    }

}
