//
//  ShowWalletTransactionsHeaderCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowWalletTransactionsHeaderCell: TableViewCell {
    
    var didTapFullHistory: () -> Void = { }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()
    
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    let recentButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .regular(size: 10.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(R.string.localizable.wallet_recent_transactions(), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let fullHistoryButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .regular(size: 10.0)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        button.setTitle(R.string.localizable.wallet_full_history(), for: .normal)
        return button
    }()
    
    let transactionsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = R.image.walletTransactions()
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x263154)
        return view
    }()
    
    override func commonInit() {
        super.commonInit()
        
        contentView.addSubview(stackView)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ buttonsStackView, separatorView ].forEach(stackView.addArrangedSubview)
        
        [ recentButton,
          SpacerView(width: 12.0),
          transactionsImageView,
          SpacerView(width: 20.0),
          fullHistoryButton ].forEach(buttonsStackView.addArrangedSubview)
        
        separatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
}
