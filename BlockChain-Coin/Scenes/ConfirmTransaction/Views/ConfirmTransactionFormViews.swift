//
//  ConfirmTransactionFormViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ConfirmTransactionFormViews {
    let orderedViews: [UIView]
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.send_confirm_title()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor(hex: 0x00ffff)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 30.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.send_confirm_subtitle()
        label.font = .regular(size: 15.0)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_infos()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let feeLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor(hex: 0x00ffff).withAlphaComponent(0.75)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()
    
    let confirmButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(R.string.localizable.send_confirm_slide_to_confirm(), for: .normal)
        return button
    }()
    
    init() {
        orderedViews = [ SpacerView(height: 20.0),
                         titleLabel,
                         SpacerView(height: 10.0),
                         amountLabel,
                         subtitleLabel,
                         SpacerView(height: 15.0),
                         addressLabel,
                         SpacerView(height: 10.0),
                         feeLabel,
                         SpacerView(height: 30.0),
                         separatorView,
                         SpacerView(height: 30.0),
                         confirmButton ]
        
        separatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
        })
    }
    
}

