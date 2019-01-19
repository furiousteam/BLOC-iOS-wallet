//
//  NewTransactionWalletCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 21/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class NewTransactionWalletCell: CollectionViewCell {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    let walletButton: SmallButton = {
        let button = SmallButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    let checkmark: UIImageView = {
        let checkmark = UIImageView(image: R.image.checkmarkSmall())
        checkmark.tintColor = .white
        checkmark.isHidden = true
        return checkmark
    }()
    
    override var isSelected: Bool {
        didSet {
            checkmark.isHidden = !isSelected
            walletButton.isSelected = isSelected
        }
    }

    override func commonInit() {
        super.commonInit()
        
        clipsToBounds = false
        contentView.clipsToBounds = false
        
        contentView.addSubview(stackView)
        
        contentView.addSubview(checkmark)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        walletButton.snp.makeConstraints({
            $0.height.equalTo(25.0)
        })
        
        [ walletButton, amountLabel ].forEach(stackView.addArrangedSubview)
        
        checkmark.snp.makeConstraints({
            $0.leading.equalTo(walletButton.snp.trailing).inset(10.0)
            $0.top.equalTo(walletButton.snp.top).inset(-7.5)
        })
    }
    
    func configure(name: String, amount: Double) {
        walletButton.setTitle(name, for: .normal)
        amountLabel.text = amount.blocCurrency(mode: .noCurrency)
    }
    
}
