//
//  ShowWalletBalanceView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ShowWalletBalanceCell: TableViewCell {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()
    
    let balanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let availableBalanceView = ShowWalletBalanceView()
    let lockedBalanceView = ShowWalletBalanceView()
    
    let balanceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = R.image.walletBalance()
        return imageView
    }()
    
    let totalBalanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let totalBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 20.0)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let totalBalanceSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        label.text = R.string.localizable.wallet_total_balance()
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
        backgroundColor = .clear
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ balanceStackView,
          totalBalanceStackView,
          SpacerView(height: 20.0),
          separatorView ].forEach(stackView.addArrangedSubview)
        
        [ availableBalanceView,
          balanceImageView,
          lockedBalanceView ].forEach(balanceStackView.addArrangedSubview)
        
        [ totalBalanceLabel,
          totalBalanceSubtitleLabel ].forEach(totalBalanceStackView.addArrangedSubview)
        
        availableBalanceView.snp.makeConstraints({
            $0.width.equalTo(lockedBalanceView.snp.width)
        })
        
        separatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
        })
    }
    
    func configure(availableBalance: Double, lockedBalance: Double) {
        availableBalanceView.configure(value: availableBalance, title: R.string.localizable.wallet_bloc_available(), alignment: .leading)
        lockedBalanceView.configure(value: lockedBalance, title: R.string.localizable.wallet_bloc_locked(), alignment: .trailing)
        totalBalanceLabel.text = (availableBalance + lockedBalance).blocCurrency()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }

}
