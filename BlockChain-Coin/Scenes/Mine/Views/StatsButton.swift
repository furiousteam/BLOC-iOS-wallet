//
//  StatsButton.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class StatsButton: View {

    var didTapStats: () -> Void = { }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5.0
        return stackView
    }()
    
    let statsLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = .white
        label.text = R.string.localizable.mining_stats().localizedUppercase
        return label
    }()
    
    let statsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.stats()
        imageView.contentMode = .center
        imageView.tintColor = .white
        return imageView
    }()

    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
        
        [ statsImageView, statsLabel ].forEach(stackView.addArrangedSubview)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(statsTapped)))
    }
    
    @objc func statsTapped() {
        didTapStats()
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
}
