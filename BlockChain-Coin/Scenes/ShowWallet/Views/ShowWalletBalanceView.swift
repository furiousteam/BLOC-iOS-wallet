//
//  ShowWalletBalanceView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowWalletBalanceView: View {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xff0000)
        return view
    }()

    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
                
        [ balanceLabel, titleLabel, SpacerView(height: 5.0), separatorView ].forEach(stackView.addArrangedSubview)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        separatorView.snp.makeConstraints({
            $0.width.equalTo(20.0)
            $0.height.equalTo(1.0 / UIScreen.main.scale)
        })
    }
    
    func configure(value: Double, title: String, alignment: UIStackViewAlignment) {
        stackView.alignment = alignment
        
        balanceLabel.text = value.blocCurrency(includeCurrency: false)
        
        titleLabel.text = title
    }

}
