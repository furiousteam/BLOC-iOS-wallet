//
//  CheckPasswordFormViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class CheckPasswordFormViews {
    let orderedViews: [UIView]
    
    let logo: UIImageView = {
        let imageView = UIImageView(image: R.image.walletMedium())
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.password_confirm_title()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.create_wallet_password_instructions()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let passwordField: FormTextField = {
        let textField = FormTextField()
        textField.placeholder = R.string.localizable.create_wallet_password_placeholder()
        textField.textField.isSecureTextEntry = true
        textField.textField.returnKeyType = .next
        return textField
    }()
    
    let nextButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(R.string.localizable.create_wallet_password_next(), for: .normal)
        return button
    }()
    
    init() {
        orderedViews = [ SpacerView(height: 25.0),
                         logo,
                         SpacerView(height: 20.0),
                         titleLabel,
                         instructionsLabel,
                         SpacerView(height: 25.0),
                         passwordField,
                         SpacerView(height: 40.0),
                         nextButton ]
    }
    
}
