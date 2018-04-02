//
//  NoTransactionsCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class NoTransactionsCell: TableViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()

    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .regular(size: 12.5)
        label.text = R.string.localizable.transactions_empty()
        label.textAlignment = .center
        return label
    }()
    
    override func commonInit() {
        super.commonInit()
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ label ].forEach(stackView.addArrangedSubview)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }

}
