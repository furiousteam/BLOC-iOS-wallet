//
//  PrintableWalletKeysView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit
import EFQRCode

class PrintableWalletKeysView: View {
    let orderedViews: [UIView]
    
    let logo: UIImageView = {
        let imageView = UIImageView(image: R.image.walletKey())
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabelFirstLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_title_first_line().localizedUppercase
        label.font = .bold(size: 15.0)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabelSecondLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_title_second_line()
        label.font = .regular(size: 15.0)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let titleLabelThirdLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_title_third_line().localizedUppercase
        label.font = .bold(size: 15.0)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_infos()
        label.font = .regular(size: 12.5)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let instructionsLabelLastLine: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_infos_last_line()
        label.font = .regular(size: 12.5)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let walletKeyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.wallet_created_qr_code().localizedUppercase
        label.font = .bold(size: 12.0)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let walletQRCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let walletKeyLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 20.0)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 40.0, bottom: 40.0, right: 40.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()
    
    let keys: String
    
    init(keys: String) {
        self.keys = keys
        
        self.orderedViews = [ logo,
                              SpacerView(height: 5.0),
                              titleLabelFirstLine,
                              titleLabelSecondLine,
                              titleLabelThirdLine,
                              SpacerView(height: 15.0),
                              instructionsLabel,
                              instructionsLabelLastLine,
                              SpacerView(height: 15.0),
                              walletKeyTitleLabel,
                              SpacerView(height: 15.0),
                              walletQRCodeImageView,
                              SpacerView(height: 15.0),
                              walletKeyLabel ]
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        super.commonInit()
        
        backgroundColor = .white
        
        addSubview(stackView)
        
        orderedViews.forEach(stackView.addArrangedSubview)
        
        walletQRCodeImageView.snp.makeConstraints({
            $0.height.equalTo(200.0)
        })

        if let qrCode = EFQRCode.generate(content: keys, size: EFIntSize(width: Int(200 * UIScreen.main.scale), height: Int(200 * UIScreen.main.scale)), backgroundColor: UIColor.black.cgColor, foregroundColor: UIColor.white.cgColor, watermark: nil) {
            walletQRCodeImageView.image = UIImage(cgImage: qrCode)
        }
        
        walletKeyLabel.text = keys
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

}
