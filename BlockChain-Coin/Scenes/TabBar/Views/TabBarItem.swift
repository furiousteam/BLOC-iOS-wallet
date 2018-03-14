//
//  TabBarItem.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class TabBarItem: View {
    
    static let height: CGFloat = 53.0
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 8.0)
        label.textColor = UIColor(hex: 0x00ffff)
        return label
    }()
    
    var markerImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.tabBarMarker())
        imageView.contentMode = .center
        imageView.tintColor = UIColor(hex: 0x00ffff)
        return imageView
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: TabBarItem.height)
    }
    
    var isSelected: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.15) { [weak self] in
                guard let `self` = self else { return }
                self.markerImageView.alpha = self.isSelected ? 1.0 : 0.0
            }
        }
    }
    
    // MARK: - View lifecycle
    
    init(image: UIImage?, title: String?, tintColor: UIColor) {
        super.init()
        
        imageView.image = image
        imageView.tintColor = tintColor
        nameLabel.text = title?.localizedUppercase
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
        addSubview(markerImageView)
        
        markerImageView.alpha = 0.0
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(6.0)
            $0.bottom.equalToSuperview().inset(9.0)
        })
        
        imageView.snp.makeConstraints({
            $0.width.width.equalTo(26.0)
        })
                
        [ imageView, nameLabel ].forEach(stackView.addArrangedSubview)
                
        markerImageView.snp.makeConstraints({
            $0.bottom.equalTo(-5.0)
            $0.width.height.equalTo(3.0)
            $0.centerX.equalToSuperview()
        })
    }
}
