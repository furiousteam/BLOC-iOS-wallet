//
//  ShowTransactionExplorerView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 25/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowTransactionExplorerView: View {

    let borderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = R.image.explorerBorder()
        return imageView
    }()
    
    let explorerLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.explorerIcon()
        imageView.contentMode = .center
        return imageView
    }()
    
    let explorerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(hex: 0x24ced4)
        label.font = .regular(size: 10.0)
        label.text = R.string.localizable.transaction_details_explorer().localizedUppercase
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.layoutMargins = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
        
        addSubview(borderImageView)
        
        [ explorerLogoImageView, explorerLabel ].forEach(stackView.addArrangedSubview)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(190.0)
            $0.centerX.equalToSuperview()
        })
        
        borderImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        explorerLogoImageView.snp.makeConstraints({
            $0.width.equalTo(60.0)
        })
        
        explorerLabel.snp.makeConstraints({
            $0.width.equalTo(130.0)
        })
    }

}
