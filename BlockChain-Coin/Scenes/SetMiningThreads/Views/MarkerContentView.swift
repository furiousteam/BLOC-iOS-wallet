//
//  MarkerContentView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MarkerContentView: View {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(stackView)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        stackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func configure(items: [String], centerAll: Bool) {
        let views = items.map { string -> UIView in
            if string.isEmpty {
                let view = UIView()
                view.backgroundColor = .yellow
                return view
            } else {
                let label = UILabel()
                label.text = string
                label.font = .regular(size: 10.0)
                label.textColor = UIColor.white.withAlphaComponent(0.5)
                label.textAlignment = .center
                return label
            }
        }
        
        if !centerAll {
            (views.first as? UILabel)?.textAlignment = .left
            (views.last as? UILabel)?.textAlignment = .right
            stackView.distribution = .fill
        } else {
            stackView.distribution = .fillEqually
        }
        
        views.forEach(stackView.addArrangedSubview)
        
        if let firstSpacer = views.first(where: { return ($0 as? UILabel == nil) }) {
            views.filter({ return ($0 as? UILabel == nil) && $0 != firstSpacer }).forEach { spacer in
                spacer.snp.makeConstraints({
                    $0.width.equalTo(firstSpacer)
                })
            }
        }
    }
    
}
