//
//  TransactionResultFormViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 23/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class TransactionResultFormViews {
    let orderedViews: [UIView]
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
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
    
    init() {
        orderedViews = [ SpacerView(height: 20.0),
                         imageView,
                         SpacerView(height: 5.0),
                         titleLabel,
                         SpacerView(height: 3.0),
                         subtitleLabel,
                         SpacerView(height: 15.0) ]
    }
    
}

