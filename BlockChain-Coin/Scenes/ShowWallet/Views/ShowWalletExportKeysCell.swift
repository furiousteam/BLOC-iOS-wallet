//
//  ShowWalletExportKeysCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowWalletExportKeysCell: TableViewCell {
    
    var didTapCopy: () -> Void = { }
    var didTapQRCode: () -> Void = { }
    
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

    let actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    let qrCodeButton = SmallButton()
    let copyButton = SmallButton()
    
    let addressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = R.image.walletExportKeys()
        return imageView
    }()
    
    let addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 12.5)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let addressSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.3)
        label.text = R.string.localizable.wallet_address()
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()
    
    var address: String?
    
    override func commonInit() {
        super.commonInit()
        
        contentView.addSubview(stackView)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [ actionsStackView,
          addressStackView,
          SpacerView(height: 20.0),
          separatorView ].forEach(stackView.addArrangedSubview)
        
        [ qrCodeButton,
          SpacerView(width: 35.0),
          addressImageView,
          SpacerView(width: 35.0),
          copyButton ].forEach(actionsStackView.addArrangedSubview)
        
        [ addressLabel,
          addressSubtitleLabel ].forEach(addressStackView.addArrangedSubview)
        
        qrCodeButton.setTitle(R.string.localizable.wallet_qr_code(), for: .normal)
        qrCodeButton.setImage(R.image.qrCodeSmall(), for: .normal)
        qrCodeButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0)
        
        qrCodeButton.addTarget(self, action: #selector(qrCodeTapped), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)

        copyButton.setTitle(R.string.localizable.wallet_keys_copy(), for: .normal)
        
        separatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
        })

        layoutSubviews()
        
        qrCodeButton.snp.makeConstraints({
            $0.height.equalTo(25.0)
            $0.width.equalTo(qrCodeButton.intrinsicContentSize.width)
        })
        
        copyButton.snp.makeConstraints({
            $0.height.equalTo(25.0)
            $0.width.equalTo(qrCodeButton.snp.width)
        })
    }
    
    func configure(address: String) {
        self.address = address
        
        addressLabel.text = address
    }
    
    // MARK: - Actions
    
    @objc func copyTapped() {
        didTapCopy()
    }
    
    @objc func qrCodeTapped() {
        didTapQRCode()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
}

