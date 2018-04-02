//
//  MiningStatsView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MiningStatsView: View {

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10.0
        return stackView
    }()
    
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    let hashRateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        label.text = R.string.localizable.mining_stats_hashrate()
        return label
    }()
    
    let pendingBalanceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        label.text = R.string.localizable.mining_stats_pending_balance()
        return label
    }()

    let activeMinersTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        label.text = R.string.localizable.mining_stats_active_miners()
        return label
    }()
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    let hashRateContentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = .white
        return label
    }()
    
    let pendingBalanceContentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = .white
        return label
    }()
    
    let activeMinersContentLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = .white
        return label
    }()
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
        
        [ titleStackView, contentStackView ].forEach(stackView.addArrangedSubview)
        
        [ hashRateTitleLabel, pendingBalanceTitleLabel, activeMinersTitleLabel ].forEach(titleStackView.addArrangedSubview)
        
        [ hashRateContentLabel, pendingBalanceContentLabel, activeMinersContentLabel ].forEach(contentStackView.addArrangedSubview)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.leading.top.bottom.equalToSuperview()
        })
    }
    
    func configure(hashRate: Double, pendingBalance: Double, activeMiners: UInt) {
        let hashRateMeasurement: Measurement = {
            if hashRate < 1_000 {
                return Measurement(value: Double(hashRate), unit: UnitHash.HashPerSec)
            } else if hashRate < 1_000_000 {
                return Measurement(value: Double(hashRate) / 1_000, unit: UnitHash.KiloHashPerSec)
            } else if hashRate < 1_000_000_000 {
                return Measurement(value: Double(hashRate) / 1_000_000, unit: UnitHash.MegaHashPerSec)
            } else {
                return Measurement(value: Double(hashRate) / 1_000_000_000, unit: UnitHash.GigaHashPerSec)
            }
        }()
        
        hashRateContentLabel.text = String(describing: hashRateMeasurement)
        pendingBalanceContentLabel.text = pendingBalance.blocCurrency(mode: .withCurrency)
        activeMinersContentLabel.text = "\(activeMiners)"
    }

}
