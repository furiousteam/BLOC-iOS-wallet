//
//  ErrorView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 24/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ErrorView: View {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 40.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView(image: R.image.transaction_error())
        imageView.contentMode = .center
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 25.5)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
        
        [ SpacerView(height: 20.0),
          imageView,
          SpacerView(height: 5.0),
          titleLabel,
          SpacerView(height: 3.0),
          subtitleLabel,
          SpacerView(height: 15.0) ].forEach(stackView.addArrangedSubview)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func configure(error: String) {
        titleLabel.text = R.string.localizable.send_error_title()
        subtitleLabel.text = error
    }
    
}
