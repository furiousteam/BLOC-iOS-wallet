//
//  ListNewsCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ListNewsCell: TableViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5.0
        stackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textAlignment = .left
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 11.0)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.numberOfLines = 5
        return label
    }()
    
    let accessoryImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.rightArrow())
        imageView.tintColor = UIColor(hex: 0x00ffff)
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()
    
    override func commonInit() {
        super.commonInit()
        
        contentView.addSubview(stackView)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        contentView.addSubview(separatorView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ textStackView, accessoryImageView ].forEach(stackView.addArrangedSubview)
        
        [ nameLabel, dateLabel ].forEach(textStackView.addArrangedSubview)
        
        accessoryImageView.snp.makeConstraints({
            $0.height.equalTo(8.5)
            $0.width.equalTo(20.5)
        })
        
        separatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.backgroundColor = selected ? UIColor(hex: 0x121f46) : .clear
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.backgroundColor = highlighted ? UIColor(hex: 0x121f46) : .clear
    }
    
    func configure(news: NewsModel) {
        nameLabel.text = news.title
        dateLabel.text = news.date.relativeShortDate()
        descriptionLabel.text = news.description
    }

}
