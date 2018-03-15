//
//  ExportWalletKeysFormViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ExportWalletKeysFormViews {
    let orderedViews: [UIView]
    
    let logo: UIImageView = {
        let imageView = UIImageView(image: R.image.walletKey())
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabelFirstLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_title_first_line().localizedUppercase
        label.font = .bold(size: 15.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabelSecondLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_title_second_line()
        label.font = .regular(size: 15.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let titleLabelThirdLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_title_third_line().localizedUppercase
        label.font = .bold(size: 15.0)
        label.textColor = UIColor(hex: 0xff0000)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_infos()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let instructionsLabelLastLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_infos_last_line()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor(hex: 0x00ffff)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let walletKeyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_qr_code().localizedUppercase
        label.font = .bold(size: 12.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let walletQRCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let walletKeyLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 20.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let printButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(R.string.localizable.wallet_created_print(), for: .normal)
        return button
    }()
    
    let goToWalletButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(R.string.localizable.wallet_created_go_to_wallet(), for: .normal)
        return button
    }()
    
    init() {
        orderedViews = [ SpacerView(height: 10.0),
                         logo,
                         SpacerView(height: 5.0),
                         titleLabelFirstLine,
                         titleLabelSecondLine,
                         titleLabelThirdLine,
                         SpacerView(height: 15.0),
                         instructionsLabel,
                         instructionsLabelLastLine,
                         SpacerView(height: 15.0),
                         walletKeyTitleLabel,
                         SpacerView(height: 15.0),
                         walletQRCodeImageView,
                         SpacerView(height: 15.0),
                         walletKeyLabel,
                         SpacerView(height: 25.0),
                         printButton,
                         SpacerView(height: 30.0),
                         goToWalletButton ]
    }
    
}
