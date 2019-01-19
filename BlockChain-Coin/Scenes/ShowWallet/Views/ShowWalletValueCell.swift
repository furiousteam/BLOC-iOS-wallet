//
//  ShowWalletValueCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 17/01/2019.
//  Copyright © 2019 BLOC.MONEY. All rights reserved.
//

import UIKit

class ShowWalletValueCell: TableViewCell {
    
    var didTapCoinGecko: () -> Void = { }
    var didTapCurrency: (String) -> Void = { _ in }

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
    
    let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 30
        return stackView
    }()
    
    let blocValueLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textAlignment = .right
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        return label
    }()

    let valueImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = R.image.walletValue()
        return imageView
    }()
    
    let coinGeckoLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        label.text = R.string.localizable.wallet_coingecko().localizedUppercase
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let totalValueLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 15.0)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let walletValueLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        label.text = R.string.localizable.wallet_value()
        label.textAlignment = .center
        return label
    }()
    
    let walletProgressLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textAlignment = .center
        return label
    }()
    
    let usdButton = SmallButton()
    let eurButton = SmallButton()
    let btcButton = SmallButton()

    let currenciesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()
    
    let topSeparatorView: UIView = {
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
        
        [ topSeparatorView,
          headerStackView,
          SpacerView(height: 5.0),
          totalValueLabel,
          walletValueLabel,
          SpacerView(height: 3.0),
          walletProgressLabel,
          SpacerView(height: 15.0),
          currenciesStackView,
          SpacerView(height: 20.0),
          separatorView ].forEach(stackView.addArrangedSubview)
        
        [ blocValueLabel,
          valueImageView,
          coinGeckoLabel ].forEach(headerStackView.addArrangedSubview)
        
        let leftSpacer = UIView()
        let rightSpacer = UIView()

        [ leftSpacer,
          usdButton,
          eurButton,
          btcButton,
          rightSpacer ].forEach(currenciesStackView.addArrangedSubview)

        coinGeckoLabel.snp.makeConstraints({
            $0.width.equalTo(blocValueLabel.snp.width)
        })

        separatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
        })
        
        topSeparatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
        })
        
        leftSpacer.snp.makeConstraints({
            $0.width.equalTo(rightSpacer)
        })
        
        coinGeckoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coinGeckTapped)))
        
        usdButton.setTitle(R.string.localizable.wallet_currency_usd(), for: .normal)
        usdButton.setImage(nil, for: .normal)
        
        eurButton.setTitle(R.string.localizable.wallet_currency_eur(), for: .normal)
        eurButton.setImage(nil, for: .normal)

        btcButton.setTitle(R.string.localizable.wallet_currency_btc(), for: .normal)
        btcButton.setImage(nil, for: .normal)
        
        usdButton.addTarget(self, action: #selector(usdTapped), for: .touchUpInside)
        eurButton.addTarget(self, action: #selector(eurTapped), for: .touchUpInside)
        btcButton.addTarget(self, action: #selector(btcTapped), for: .touchUpInside)
        
        usdButton.snp.makeConstraints({
            $0.height.equalTo(25.0)
            $0.width.equalTo(usdButton.intrinsicContentSize.width)
        })
        
        eurButton.snp.makeConstraints({
            $0.height.equalTo(25.0)
            $0.width.equalTo(eurButton.intrinsicContentSize.width)
        })

        btcButton.snp.makeConstraints({
            $0.height.equalTo(25.0)
            $0.width.equalTo(btcButton.intrinsicContentSize.width)
        })
    }
    
    @objc func usdTapped() {
        didTapCurrency("USD")
    }
    
    @objc func eurTapped() {
        didTapCurrency("EUR")
    }

    @objc func btcTapped() {
        didTapCurrency("BTC")
    }
    
    @objc func coinGeckTapped() {
        didTapCoinGecko()
    }
    
    func configure(blocValue: Double, totalValue: Double, evolution: Double, selectedCurrency: String) {
        blocValueLabel.text = "1 BLOC = \(blocValue.otherCurrency(code: selectedCurrency))"
        totalValueLabel.text = totalValue.otherCurrency(code: selectedCurrency)
        walletProgressLabel.text = String(format: "%.2f%% / 24h", evolution)
        walletProgressLabel.textColor = (evolution >= 0.0 ? UIColor(hex: 0x00ff00).withAlphaComponent(0.5) : UIColor(hex: 0xff0000))
        usdButton.isSelected = (selectedCurrency == "USD")
        eurButton.isSelected = (selectedCurrency == "EUR")
        btcButton.isSelected = (selectedCurrency == "BTC")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
}
