//
//  ShowTransactionMultiColumnView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 25/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ShowTransactionMultiColumnView: View {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()

    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
        
        addSubview(separatorView)
        
        [ leftLabel, rightLabel ].forEach(stackView.addArrangedSubview)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(10.0)
            $0.bottom.equalToSuperview().inset(10.0)
        })
        
        separatorView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }
    
    func configure(leftContent: NSAttributedString, rightContent: NSAttributedString) {
        leftLabel.attributedText = leftContent
        rightLabel.attributedText = rightContent
    }

}
