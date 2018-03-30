//
//  MarkerBarsView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MarkerBarsView: View {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let dashedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(patternImage: R.image.separatorDash()!)
        return view
    }()
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
        
        addSubview(dashedView)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        dashedView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        })
    }
    
    func configure(count: Int) {
        let viewsCount = (count*2) + 1
        
        var views = (0...viewsCount).map { index -> UIView in
            if index % 2 == 0 {
                let imageView = UIImageView(image: R.image.markerVerticalSeparator())
                imageView.tintColor = UIColor.white.withAlphaComponent(0.5)
                imageView.contentMode = .center
                return imageView
            } else {
                let view = UIView()
                view.backgroundColor = .yellow
                return view
            }
        }
        
        if (viewsCount % 2 != 0) {
            views.removeLast()
        }
        
        views.first?.contentMode = .left
        views.last?.contentMode = .right
        
        views.forEach(stackView.addArrangedSubview)
        
        if let firstSpacer = views.first(where: { return ($0 as? UIImageView == nil) }) {
            views.filter({ return ($0 as? UIImageView == nil) && $0 != firstSpacer }).forEach { spacer in
                spacer.snp.makeConstraints({
                    $0.width.equalTo(firstSpacer)
                })
            }
        }
    }
    
}
