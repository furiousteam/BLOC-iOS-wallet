//
//  DeleteWalletViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 04/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class DeleteWalletViews {
    let orderedViews: [UIView]
    
    let logo: UIImageView = {
        let imageView = UIImageView(image: R.image.deleteIcon())
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hex: 0xff0000)
        return imageView
    }()
    
    let titleLabelFirstLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.delete_wallet_title().localizedUppercase
        label.font = .bold(size: 15.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabelSecondLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.delete_wallet_important().localizedUppercase
        label.font = .regular(size: 15.0)
        label.textColor = UIColor(hex: 0xff0000)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.delete_wallet_text()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let instructionsLabelLastLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.delete_wallet_text_bold()
        label.font = .bold(size: 12.5)
        label.textColor = UIColor(hex: 0x00ffff)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let tapToDeleteLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.delete_wallet_before_action().localizedUppercase
        label.font = .regular(size: 15.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let deleteButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(R.string.localizable.delete_wallet_action().localizedUppercase, for: .normal)
        button.tintColor = UIColor(hex: 0xff0000)
        button.layer.shadowOpacity = 0.0
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    init() {
        orderedViews = [ SpacerView(height: 10.0),
                         logo,
                         SpacerView(height: 5.0),
                         titleLabelFirstLine,
                         titleLabelSecondLine,
                         SpacerView(height: 15.0),
                         instructionsLabel,
                         SpacerView(height: 10.0),
                         instructionsLabelLastLine,
                         SpacerView(height: 15.0),
                         tapToDeleteLabel,
                         SpacerView(height: 15.0),
                         deleteButton ]
    }
    
}
