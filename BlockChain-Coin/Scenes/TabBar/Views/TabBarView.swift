//
//  TabBarView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import SnapKit

final class TabBarView: View {
    var didSelectTab: (Int) -> Void = { _ in }
    
    var items: [UITabBarItem] = [] {
        didSet {
            configureTabs()
        }
    }
    
    let backgroundView: UIImageView = {
        let imageView = UIImageView(image: R.image.tabBarBg())
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: - View lifecycke
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(backgroundView)
        addSubview(stackView)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        backgroundView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(53.0)
        })
        
        stackView.snp.makeConstraints({
            $0.bottom.top.equalToSuperview()
            $0.width.equalToSuperview().inset(20.0)
            $0.centerX.equalToSuperview()
        })
    }
    
    // MARK: - Configuration
    
    fileprivate func configureTabs() {
        stackView.arrangedSubviews.forEach({
            self.stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
        
        let subviews: [TabBarItem] = items.enumerated().map({ (index, item) -> TabBarItem in
            let tabItem = TabBarItem(image: item.image, title: item.title, tintColor: (index == 2 ? UIColor.white : UIColor.white.withAlphaComponent(0.5)))
            tabItem.tag = index
            tabItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTapped(tap:))))
            return tabItem
        })
        
        subviews.forEach(stackView.addArrangedSubview)
    }
    
    // MARK: - Actions
    
    @objc func tapTapped(tap: UITapGestureRecognizer) {
        guard let view = tap.view else { return }
        
        didSelectTab(view.tag)
    }
    
    // MARK: - UI
    
    func setActiveTab(index: Int) {
        stackView.subviews.flatMap({ $0 as? TabBarItem }).enumerated().forEach { offset, element in
            element.isSelected = (offset == index)
        }
    }
}
