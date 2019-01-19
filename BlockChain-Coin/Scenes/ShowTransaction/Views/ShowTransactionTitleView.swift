//
//  ShowTransactionTitleView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 25/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ShowTransactionTitleView: View {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 15.0)
        label.textColor = .white
        return label
    }()
    
    let typeView = ShowTransactionTypeView()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()

    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
        
        addSubview(separatorView)
        
        backgroundColor = .clear
                
        [ titleLabel, typeView ].forEach(stackView.addArrangedSubview)
    }
    
    func configure(transaction: ListTransactionItemViewModel) {
        titleLabel.text = transaction.name
        typeView.configure(type: transaction.transaction.transactionType)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(5.0)
            $0.bottom.equalToSuperview().inset(15.0)
            $0.height.equalTo(25.0)
        })

        separatorView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }
}
