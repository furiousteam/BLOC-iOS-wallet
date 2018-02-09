//
//  PoolStatusView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 09/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class PoolStatusView: View {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 25.0, bottom: 15.0, right: 25.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xEEEEEE)
        return view
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor(hex: 0xBFBFBF)
        return label
    }()
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
        
        [ statusLabel, addressLabel ].forEach(stackView.addArrangedSubview)
        
        addSubview(separatorView)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        separatorView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }
    
    func configure(status: String, address: String) {
        let boldAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.systemFont(ofSize: 14.0, weight: .bold),
                                                             .foregroundColor: UIColor.black ]
        
        let regularAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
                                                                .foregroundColor: UIColor.black ]
        
        let attrString = NSMutableAttributedString(string: "Pool Status: ", attributes: boldAttributes)
        
        let statusAttrString = NSAttributedString(string: status, attributes: regularAttributes)
        
        attrString.append(statusAttrString)

        statusLabel.attributedText = attrString
        
        addressLabel.text = address
    }
}
