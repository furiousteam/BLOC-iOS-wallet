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
    
    let activeIndicator = ActiveTabIndicator()
    var activeIndicatorWidth = 20.0
    
    // MARK: - View lifecycke
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(backgroundView)
        addSubview(stackView)
        addSubview(activeIndicator)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        backgroundView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50.0)
        })
        
        stackView.snp.makeConstraints({
            $0.bottom.top.equalToSuperview()
            $0.width.equalToSuperview().inset(20.0)
            $0.centerX.equalToSuperview()
        })
        
        activeIndicator.snp.makeConstraints({
            $0.height.equalTo(3.0)
            $0.width.equalTo(activeIndicatorWidth)
            $0.bottom.equalTo(stackView)
            $0.leading.equalTo(stackView).inset(0.0)
        })
    }
    
    // MARK: - Configuration
    
    fileprivate func configureTabs() {
        stackView.arrangedSubviews.forEach({
            self.stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
        
        let subviews: [TabBarItem] = items.enumerated().map({ (index, item) -> TabBarItem in
            let tabItem = TabBarItem(image: item.image)
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
        guard index < stackView.arrangedSubviews.count else { return }
        
        let offset = Double(stackView.arrangedSubviews[index].frame.minX)
        let width = Double(stackView.arrangedSubviews[index].frame.width)
        
        moveIndicator(offset: offset, targetWidth: width)
    }
    
    fileprivate func moveIndicator(offset: Double, targetWidth: Double, animated: Bool = true) {
        let additionalOffsetToCenter = max(0.0, targetWidth - self.activeIndicatorWidth) / 2.0
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            guard let `self` = self else { return }
            
            self.activeIndicator.snp.updateConstraints({
                $0.leading.equalTo(self.stackView).inset(offset + additionalOffsetToCenter)
                $0.width.equalTo(self.activeIndicatorWidth)
            })
            
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
