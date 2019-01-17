//
//  NewTransactionsFormViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 21/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import SZTextView
import CenterAlignedCollectionViewFlowLayout

class NewTransactionsFormViews: NSObject, UITextViewDelegate {
    let orderedViews: [UIView]
    
    // Amount Input
    
    let amountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.send_amount_title()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let amountTextField: TextField = {
        let textField = TextField()
        textField.borderStyle = .none
        textField.font = .regular(size: 30.0)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.keyboardType = .decimalPad
        
        let placeholderStyle: [NSAttributedStringKey: Any] = [ .font: UIFont.regular(size: 30.0),
                                                               .foregroundColor: UIColor.white ]
        
        let attributedPlaceholder = NSAttributedString(string: (0.0).blocCurrency(mode: .noCurrency), attributes: placeholderStyle)
        
        textField.attributedPlaceholder = attributedPlaceholder

        textField.accessibilityLabel = "Amount"
        
        return textField
    }()
    
    let feeLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.send_amount_fees((0.0001).blocCurrency())
        label.font = .regular(size: 12.5)
        label.textColor = UIColor(hex: 0x00ffff)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let anonymityLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.send_anonymity()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let amountSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()
    
    // Payment ID
    
    let paymentIDTitleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.payment_id_title()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let paymentIDTextView: SZTextView = {
        let textView = SZTextView()
        textView.placeholder = R.string.localizable.send_paste_payment_id()
        textView.placeholderTextColor = UIColor.white.withAlphaComponent(0.5)
        textView.font = .regular(size: 12.5)
        textView.textColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.accessibilityLabel = "Recipient address"
        return textView
    }()
    
    let paymentIDSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()

    // Recipient
    
    let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.send_recipient_title()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let addressActionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let qrCodeLeftSpacerView = SpacerView(width: 10.0)
    let qrCodeRightSpacerView = SpacerView(width: 10.0)

    let qrCodeButton: SmallButton = {
        let button = SmallButton()
        button.setTitle(R.string.localizable.send_use_qr_code(), for: .normal)
        button.setImage(R.image.qrCodeSmall(), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0)
        return button
    }()
    
    let addressTextView: SZTextView = {
        let textView = SZTextView()
        textView.placeholder = R.string.localizable.send_paste_address()
        textView.placeholderTextColor = UIColor.white.withAlphaComponent(0.5)
        textView.font = .regular(size: 12.5)
        textView.textColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.accessibilityLabel = "Recipient address"
        return textView
    }()

    let addressSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()
    
    // Wallets
    
    let walletsTitle: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.send_select_wallet()
        label.font = .regular(size: 10.0)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let walletsCollectionView: UICollectionView = {
        let layout = CenterAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    // Action
    
    let sendButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(R.string.localizable.send_action(), for: .normal)
        return button
    }()
        
    override init() {
        amountSeparatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
        })
        
        addressSeparatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
        })
        
        paymentIDSeparatorView.snp.makeConstraints({
            $0.height.equalTo(1.0)
        })
        
        addressTextView.snp.makeConstraints({
            $0.height.greaterThanOrEqualTo(75.0)
        })
        
        paymentIDTextView.snp.makeConstraints({
            $0.height.greaterThanOrEqualTo(50.0)
        })
        
        NewTransactionWalletCell.registerWith(walletsCollectionView)
        NewTransactionNoWalletCell.registerWith(walletsCollectionView)
        
        walletsCollectionView.snp.makeConstraints({
            $0.height.equalTo(0.0)
        })
        
        [ qrCodeLeftSpacerView, qrCodeButton, qrCodeRightSpacerView ].forEach(addressActionsStackView.addArrangedSubview)
        
        orderedViews = [ SpacerView(height: 15.0),
                         amountTitleLabel,
                         SpacerView(height: 15.0),
                         amountTextField,
                         SpacerView(height: 10.0),
                         feeLabel,
                         SpacerView(height: 15.0),
                         amountSeparatorView,
                         SpacerView(height: 15.0),
                         paymentIDTitleLabel,
                         SpacerView(height: 10.0),
                         paymentIDTextView,
                         SpacerView(height: 15.0),
                         paymentIDSeparatorView,
                         SpacerView(height: 15.0),
                         addressTitleLabel,
                         SpacerView(height: 10.0),
                         addressActionsStackView,
                         SpacerView(height: 10.0),
                         addressTextView,
                         SpacerView(height: 15.0),
                         addressSeparatorView,
                         SpacerView(height: 15.0),
                         walletsTitle,
                         SpacerView(height: 20.0),
                         walletsCollectionView,
                         SpacerView(height: 30.0),
                         sendButton ]

        super.init()
        
        addressTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let _ = text.rangeOfCharacter(from: CharacterSet.newlines) {
            textView.endEditing(true)

            return false
        }
        
        return true
    }
    
}
