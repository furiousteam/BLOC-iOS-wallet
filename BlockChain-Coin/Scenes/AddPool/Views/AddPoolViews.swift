//
//  AddPoolViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class AddPoolViews {
    let orderedViews: [UIView]
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.mining_pool_add_title()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let urlField: FormTextField = {
        let textField = FormTextField()
        textField.placeholder = R.string.localizable.mining_pool_url_placeholder()
        textField.textField.returnKeyType = .next
        textField.textField.keyboardType = .URL
        textField.textField.autocorrectionType = .no
        textField.textField.autocapitalizationType = .none
        return textField
    }()
    
    let portField: FormTextField = {
        let textField = FormTextField()
        textField.placeholder = R.string.localizable.mining_pool_port_placeholder()
        textField.textField.returnKeyType = .send
        textField.textField.keyboardType = .numberPad
        return textField
    }()

    let addButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(R.string.localizable.mining_pool_add(), for: .normal)
        return button
    }()
    
    init() {
        orderedViews = [ SpacerView(height: 25.0),
                         titleLabel,
                         SpacerView(height: 25.0),
                         urlField,
                         SpacerView(height: 10.0),
                         portField,
                         SpacerView(height: 40.0),
                         addButton ]
    }
    
}

