//
//  ScrollableStackView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import SnapKit

class ScrollableStackView: View {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.preservesSuperviewLayoutMargins = false
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 40.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.preservesSuperviewLayoutMargins = true
        return stackView
    }()
    
    override func commonInit() {
        super.commonInit()
        
        preservesSuperviewLayoutMargins = false
        
        scrollView.setupKeyboardHandling()
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    deinit {
        scrollView.destroyKeyboardHandling()
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        scrollView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        stackView.snp.makeConstraints({
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.lessThanOrEqualToSuperview()
        })
    }
    
}
