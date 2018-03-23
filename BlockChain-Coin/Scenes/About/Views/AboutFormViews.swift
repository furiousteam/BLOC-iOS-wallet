//
//  AboutFormViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 23/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class AboutFormViews {
    let orderedViews: [UIView]
    
    let logo: UIImageView = {
        let imageView = UIImageView(image: R.image.aboutLogo())
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.about_us_tagline().localizedUppercase
        label.font = .light(size: 23.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let meetLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.about_us_meet().localizedUppercase
        label.font = .bold(size: 23.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let blocLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.about_us_bloc().localizedUppercase
        label.font = .light(size: 23.0)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let websiteButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let attributes: [NSAttributedStringKey: Any] = [ .font: UIFont.regular(size: 10.0),
                                                         .foregroundColor: UIColor(hex: 0x00ffff),
                                                         .kern: 2.0]
        
        button.setAttributedTitle(NSAttributedString(string: R.string.localizable.about_us_url(), attributes: attributes), for: .normal)
        
        return button
    }()

    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.about_us_content()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        orderedViews = [ SpacerView(height: 10.0),
                         logo,
                         SpacerView(height: 10.0),
                         taglineLabel,
                         SpacerView(height: 10.0),
                         meetLabel,
                         blocLabel,
                         SpacerView(height: 10.0),
                         websiteButton,
                         SpacerView(height: 15.0),
                         contentLabel ]
    }
    
}

