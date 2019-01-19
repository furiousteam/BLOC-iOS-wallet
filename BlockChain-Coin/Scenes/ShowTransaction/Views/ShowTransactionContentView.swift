//
//  ShowTransactionContentView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 25/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ShowTransactionContentView: View {

    let label: UILabel = {
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
        
        addSubview(label)
        
        addSubview(separatorView)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        label.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(10.0)
            $0.bottom.equalToSuperview().inset(10.0)
        })
        
        separatorView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }
    
    func configure(content: NSAttributedString) {
        label.attributedText = content
    }

}
