//
//  NewTransactionNoWalletCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class NewTransactionNoWalletCell: CollectionViewCell {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = R.string.localizable.send_no_wallet()
        return label
    }()
    
    override func commonInit() {
        super.commonInit()
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ titleLabel ].forEach(stackView.addArrangedSubview)
    }
    
}
