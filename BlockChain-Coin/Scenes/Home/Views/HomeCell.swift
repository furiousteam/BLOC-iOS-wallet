//
//  HomeCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class HomeCell: TableViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 18.0, right: 0.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 20.0)
        label.textColor = .white
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor(hex: 0x156478)
        return label
    }()
    
    let highlightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.menuHighlight()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func commonInit() {
        super.commonInit()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ nameLabel, subtitleLabel ].forEach(stackView.addArrangedSubview)
        
        contentView.insertSubview(highlightImageView, belowSubview: stackView)
        
        highlightImageView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.height.width.equalTo(105.0)
        })
        
        highlightImageView.alpha = 0.0
        
        contentView.clipsToBounds = false
        clipsToBounds = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.highlightImageView.alpha = selected ? 1.0 : 0.0
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.highlightImageView.alpha = highlighted ? 1.0 : 0.0
        }
    }
    
    func configure(for item: HomeItem) {
        nameLabel.text = item.title.localizedUppercase
        subtitleLabel.text = item.subtitle
    }

}
