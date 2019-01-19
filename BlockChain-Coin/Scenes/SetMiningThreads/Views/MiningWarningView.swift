//
//  MiningWarningView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class MiningWarningView: View {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.layoutMargins = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 15.0)
        label.textColor = UIColor(hex: 0xff0000)
        label.numberOfLines = 0
        label.text = R.string.localizable.mining_threads_important().localizedUppercase
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let regularAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.regular(size: 12.5), .foregroundColor: UIColor.white ]
        let boldAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.bold(size: 12.5), .foregroundColor: UIColor(hex: 0x00ffff) ]
        
        let regularAttrString = NSAttributedString(string: "\(R.string.localizable.mining_threads_important_content_regular()) ", attributes: regularAttributes)
        let boldAttrString = NSAttributedString(string: R.string.localizable.mining_threads_important_content_bold(), attributes: boldAttributes)
        
        let attrString = NSMutableAttributedString(attributedString: regularAttrString)
        attrString.append(boldAttrString)
        
        label.attributedText = attrString
        
        return label
    }()

    override func commonInit() {
        super.commonInit()
        
        backgroundColor = UIColor(hex: 0x000627)

        addSubview(stackView)
        
        stackView.addSubview(textStackView)
        
        [ textStackView ].forEach(stackView.addArrangedSubview)
        
        [ titleLabel, contentLabel ].forEach(textStackView.addArrangedSubview)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
}

