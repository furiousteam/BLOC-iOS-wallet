//
//  ImportWalletKeyFormViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit
import SZTextView

class ImportWalletKeyFormViews {
    let orderedViews: [UIView]
    
    let logo: UIImageView = {
        let imageView = UIImageView(image: R.image.walletKey())
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.import_wallet_key_title()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let textView: SZTextView = {
        let textView = SZTextView()
        textView.placeholder = R.string.localizable.import_wallet_key_placeholder()
        textView.placeholderTextColor = UIColor.white.withAlphaComponent(0.5)
        textView.font = .regular(size: 12.5)
        textView.textColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        textView.textAlignment = .center
        textView.backgroundColor = UIColor(hex: 0x010c2e)
        textView.layer.cornerRadius = 4.0
        return textView
    }()

    let nextButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(R.string.localizable.create_wallet_password_next(), for: .normal)
        return button
    }()
    
    init() {
        textView.snp.makeConstraints({
            $0.height.equalTo(150.0)
        })
        
        orderedViews = [ SpacerView(height: 10.0),
                         logo,
                         SpacerView(height: 10.0),
                         titleLabel,
                         SpacerView(height: 15.0),
                         textView,
                         SpacerView(height: 30.0),
                         nextButton ]
    }
    
}
