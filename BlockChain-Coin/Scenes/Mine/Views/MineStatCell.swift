//
//  MineStatCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 09/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MineStatCell: TableViewCell {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        return label
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
        
        [ leftLabel, rightLabel ].forEach(stackView.addArrangedSubview)
        
        leftLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        leftLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        rightLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        separatorView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }
    
    func configure(title: String, value: String) {
        leftLabel.text = title
        rightLabel.text = value
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
}
