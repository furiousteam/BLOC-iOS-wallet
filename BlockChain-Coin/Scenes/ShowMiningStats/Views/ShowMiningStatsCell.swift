//
//  ShowMiningStatsCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowMiningStatsCell: TableViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 15.0
        stackView.layoutMargins = UIEdgeInsets(top: 25.0, left: 20.0, bottom: 25.0, right: 20.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()
    
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    let accessoryImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.rightArrow())
        imageView.tintColor = UIColor(hex: 0x00ffff)
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 13.0)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    let titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    let firstTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    let secondTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()

    let thirdTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()

    let fourthTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()

    let fifthTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    let firstContentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        return label
    }()
    
    let secondContentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        return label
    }()
    
    let thirdContentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        return label
    }()
    
    let fourthContentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        return label
    }()
    
    let fifthContentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        return label
    }()
        
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()

    override func commonInit() {
        super.commonInit()
        
        contentView.backgroundColor = .clear
        backgroundColor = contentView.backgroundColor
        
        contentView.addSubview(separatorView)
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ titleStackView, contentStackView ].forEach(stackView.addArrangedSubview)
        
        [ accessoryImageView, titleLabel ].forEach(titleStackView.addArrangedSubview)
        
        [ titleImageView, titlesStackView, contentsStackView ].forEach(contentStackView.addArrangedSubview)
        
        [ firstTitleLabel, secondTitleLabel, thirdTitleLabel, fourthTitleLabel, fifthTitleLabel ].forEach(titlesStackView.addArrangedSubview)
        
        [ firstContentLabel, secondContentLabel, thirdContentLabel, fourthContentLabel, fifthContentLabel ].forEach(contentsStackView.addArrangedSubview)

        accessoryImageView.snp.makeConstraints({
            $0.height.equalTo(6.0)
            $0.width.equalTo(14.0)
        })
        
        titleImageView.snp.makeConstraints({
            $0.width.equalTo(50.0)
        })
        
        separatorView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
    func configure(title: String, image: UIImage, titles: [String], content: [String]) {
        titleLabel.text = title
        titleImageView.image = image
        
        if titles.count > 0, content.count > 0 {
            firstTitleLabel.isHidden = false
            firstTitleLabel.text = titles[0]
            
            firstContentLabel.isHidden = false
            firstContentLabel.text = content[0]
        } else {
            firstContentLabel.isHidden = true
            firstTitleLabel.isHidden = true
        }
        
        if titles.count > 1, content.count > 1 {
            secondTitleLabel.isHidden = false
            secondTitleLabel.text = titles[1]
            
            secondContentLabel.isHidden = false
            secondContentLabel.text = content[1]
        } else {
            secondTitleLabel.isHidden = true
            secondContentLabel.isHidden = true
        }

        if titles.count > 2, content.count > 2 {
            thirdTitleLabel.isHidden = false
            thirdTitleLabel.text = titles[2]
            
            thirdContentLabel.isHidden = false
            thirdContentLabel.text = content[2]
        } else {
            thirdTitleLabel.isHidden = true
            thirdContentLabel.isHidden = true
        }

        if titles.count > 3, content.count > 3 {
            fourthTitleLabel.isHidden = false
            fourthTitleLabel.text = titles[3]
            
            fourthContentLabel.isHidden = false
            fourthContentLabel.text = content[3]
        } else {
            fourthTitleLabel.isHidden = true
            fourthContentLabel.isHidden = true
        }

        if titles.count > 4, content.count > 4 {
            fifthTitleLabel.isHidden = false
            fifthTitleLabel.text = titles[4]
            
            fifthContentLabel.isHidden = false
            fifthContentLabel.text = content[4]
        } else {
            fifthTitleLabel.isHidden = true
            fifthContentLabel.isHidden = true
        }
    }

}
