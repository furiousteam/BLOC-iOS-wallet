//
//  TitleView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class TitleView: View {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 20.0)
        label.textColor = .white
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor(hex: 0x156478)
        return label
    }()
    
    init(title: String, subtitle: String?) {
        super.init()
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        super.commonInit()
        
        backgroundColor = .clear
        
        addSubview(stackView)
        
        [ titleLabel, subtitleLabel ].forEach(stackView.addArrangedSubview)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.top.equalToSuperview().inset(-10.0)
            $0.leading.trailing.bottom.equalToSuperview()
        })
    }
    
}
