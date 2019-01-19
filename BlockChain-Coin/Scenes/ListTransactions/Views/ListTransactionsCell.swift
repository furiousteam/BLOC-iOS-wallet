//
//  ListTransactionsCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 24/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ListTransactionsCell: TableViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textAlignment = .left
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textAlignment = .right
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        return label
    }()
    
    let typeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
        
        contentView.addSubview(stackView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(typeImageView)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(separatorView)
        
        stackView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20.0)
            $0.top.equalTo(7.0)
            $0.height.equalTo(25.0)
        })
        
        [ nameLabel, dateLabel ].forEach(stackView.addArrangedSubview)
        
        amountLabel.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.height.equalTo(40.0)
        })
        
        nameLabel.snp.makeConstraints({
            $0.width.lessThanOrEqualTo(100.0)
        })
        
        typeLabel.snp.makeConstraints({
            $0.leading.equalTo(stackView.snp.trailing).offset(5.0)
            $0.height.equalTo(40.0)
        })
        
        typeImageView.snp.makeConstraints({
            $0.leading.equalTo(typeLabel.snp.trailing).offset(2.0)
            $0.width.equalTo(10)
            $0.height.equalTo(8.5)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20.0)
        })
        
        separatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
        })
        
        amountLabel.setContentCompressionResistancePriority(.init(700.0), for: .horizontal)
        amountLabel.setContentHuggingPriority(.init(700.0), for: .horizontal)
        
        amountLabel.setContentCompressionResistancePriority(.init(700.0), for: .horizontal)
        amountLabel.setContentHuggingPriority(.init(700.0), for: .horizontal)
        
        typeLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        typeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    func configure(transaction: ListTransactionItemViewModel, backgroundColor: UIColor) {
        contentView.backgroundColor = backgroundColor
        self.backgroundColor = backgroundColor
        
        nameLabel.text = transaction.name
        dateLabel.text = transaction.transaction.createdAt.shortDate()
        typeLabel.text = transaction.transaction.transactionType.text
        typeLabel.textColor = transaction.transaction.transactionType.color
        typeImageView.image = transaction.transaction.transactionType.smallImage
        amountLabel.attributedText = transaction.transaction.amount.blocCurrencyWithColor(mode: .withCurrencyAndPrefix)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }

}
