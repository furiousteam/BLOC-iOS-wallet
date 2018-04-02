//  
//  MineLowPowerVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MineLowPowerVC: ViewController, UIGestureRecognizerDelegate {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 25.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(image: R.image.lowPowerBig())
        imageView.contentMode = .center
        imageView.tintColor = UIColor.white.withAlphaComponent(0.75)
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.mining_low_power_title().localizedUppercase
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .regular(size: 12.5)
        label.textColor = .white
        return label
    }()
    
    let hashrateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let pendingBalanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    let activerMinersLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var timer: Timer?
    var globalTap: UITapGestureRecognizer?
    
    let router: MineLowPowerRoutingLogic
    
    // MARK: - View lifecycle
    
    init() {
        let router = MineLowPowerRouter()
        
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
        
        router.viewController = self
    }
    
    init(router: MineLowPowerRoutingLogic) {
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }

    // MARK: - Configuration
    
    override func configure() {
        super.configure()
        
        view.backgroundColor = UIColor(hex: 0x00000f)
        
        // Subviews
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        })
        
        [ imageView,
          SpacerView(height: 15.0),
          titleLabel,
          SpacerView(height: 15.0),
          hashrateLabel,
          SpacerView(height: 2.0),
          pendingBalanceLabel,
          SpacerView(height: 2.0),
          activerMinersLabel ].forEach(stackView.addArrangedSubview)
        
        globalTap = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        
        if let globalTap = globalTap {
            globalTap.delegate = self
            view.addGestureRecognizer(globalTap)
        }
        
        resetTimer()
        
        // Navigation Bar
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == globalTap {
            resetTimer()
        }
        
        return false
    }
    
    func resetTimer() {
        timer?.invalidate()
        NotificationCenter.default.post(name: .restoreBrightness, object: nil)

        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false, block: { timer in
            NotificationCenter.default.post(name: .reduceBrightness, object: nil)
        })
    }
    
    @objc func didTapView() {
    }
    
    @objc func backTapped() {
        router.goBack()
    }
    
    func configure(hashRate: Double, totalHashes: UInt, sharesFound: UInt, activeMiners: UInt, pendingBalance: Double) {
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
        
        let titleAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.regular(size: 10.0), .foregroundColor: UIColor.white.withAlphaComponent(0.5) ]
        let contentAttributes: [NSAttributedStringKey: Any] = [ .font: UIFont.regular(size: 10.0), .foregroundColor: UIColor.white ]
        
        let hashRateAttrString = NSMutableAttributedString(string: "\(R.string.localizable.mining_stats_hashrate()) ", attributes: titleAttributes)
        let hashRateContentAttrString = NSAttributedString(string: String(describing: hashRateMeasurement), attributes: contentAttributes)
        hashRateAttrString.append(hashRateContentAttrString)
        hashrateLabel.attributedText = hashRateAttrString
        
        let pendingAttrString = NSMutableAttributedString(string: "\(R.string.localizable.mining_stats_pending_balance()) ", attributes: titleAttributes)
        let pendingContentAttrString = NSAttributedString(string: pendingBalance.blocCurrency(mode: .withCurrency), attributes: contentAttributes)
        pendingAttrString.append(pendingContentAttrString)
        pendingBalanceLabel.attributedText = pendingAttrString

        let minersAttrString = NSMutableAttributedString(string: "\(R.string.localizable.mining_stats_active_miners()) ", attributes: titleAttributes)
        let minersContentAttrString = NSAttributedString(string: "\(activeMiners)", attributes: contentAttributes)
        minersAttrString.append(minersContentAttrString)
        activerMinersLabel.attributedText = minersAttrString
    }
}
