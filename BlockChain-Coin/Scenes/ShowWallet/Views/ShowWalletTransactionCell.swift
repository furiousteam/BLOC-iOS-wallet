//
//  ShowWalletTransactionCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ShowWalletTransactionCell: TableViewCell {
    
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
        view.backgroundColor = UIColor(hex: 0x263154)
        return view
    }()
    
    override func commonInit() {
        super.commonInit()
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(typeImageView)

        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(separatorView)
        
        dateLabel.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20.0)
            $0.height.equalTo(40.0)
        })
        
        amountLabel.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.height.equalTo(40.0)
        })
        
        typeLabel.snp.makeConstraints({
            $0.leading.equalTo(dateLabel.snp.trailing).offset(5.0)
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
    
    func configure(transaction: TransactionModel) {
        dateLabel.text = transaction.createdAt.shortDate()
        amountLabel.attributedText = transaction.amount.blocCurrencyWithColor(mode: .withCurrencyAndPrefix)
        typeLabel.text = transaction.transactionType.text
        typeLabel.textColor = transaction.transactionType.color
        typeImageView.image = transaction.transactionType.smallImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }

}
