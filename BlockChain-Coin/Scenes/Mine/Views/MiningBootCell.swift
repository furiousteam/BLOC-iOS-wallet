//
//  MiningBootCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 28/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MiningBootCell: TableViewCell {

    var didChangeSwitch: (Bool) -> Void = { _ in }
    
    let miningBooterView = MiningBooterView()
    let miningSwitchView = MiningSwitchView()
    
    let statsView = MiningStatsView()
    let statsButton = StatsButton()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()
    
    override func commonInit() {
        super.commonInit()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(miningBooterView)
        contentView.addSubview(miningSwitchView)
        contentView.addSubview(statsView)
        contentView.addSubview(statsButton)

        contentView.addSubview(separatorView)
        
        miningSwitchView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.centerY.equalToSuperview().offset(-60.0)
            } else {
                $0.centerY.equalToSuperview().offset(-10.0)
            }
            $0.width.equalTo(110.0)
            $0.height.equalTo(51.0)
        })
        
        miningBooterView.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.centerY.equalToSuperview().offset(-60.0)
            } else {
                $0.centerY.equalToSuperview().offset(-10.0)
            }
        })
        
        statsView.snp.makeConstraints({
            $0.leading.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview().inset(15.0)
        })
        
        statsButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview().inset(15.0)
        })
        
        separatorView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(15.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(enableSwitch), name: Notification.Name("miningSwitchEnable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeState), name: Notification.Name("miningSwitchChangeState"), object: nil)

        miningSwitchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchTapped)))
    }
    
    @objc func enableSwitch(notification: Notification) {
        let isEnabled = (notification.object as? Bool) ?? true
        
        miningSwitchView.isUserInteractionEnabled = isEnabled
        
        if !isEnabled {
            miningBooterView.configure(isOn: isEnabled)
            miningSwitchView.isOn = isEnabled
        }
    }
    
    @objc func changeState(notification: Notification) {
        switchTapped()
    }
    
    @objc func switchTapped() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let lastState = miningSwitchView.isOn
        
        didChangeSwitch(!lastState)
        
        miningBooterView.configure(isOn: !lastState)
        miningSwitchView.isOn = !lastState
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }

}
