//
//  NoWalletInstructionsCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class NoWalletInstructionsCell: TableViewCell {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 25.0, left: 40.0, bottom: 25.0, right: 40.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .light(size: 22.0)
        label.numberOfLines = 0
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.textAlignment = .center
        return label
    }()
    
    override func commonInit() {
        super.commonInit()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ titleLabel ].forEach(stackView.addArrangedSubview)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
    func configure(title: String) {
        titleLabel.text = title.localizedUppercase
    }
    
}

