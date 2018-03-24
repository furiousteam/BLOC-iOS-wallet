//
//  ErrorTableViewCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 24/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ErrorTableViewCell: TableViewCell {
    
    let errorView = ErrorView()
    
    // MARK: - View lifecycle
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(errorView)
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        errorView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func configure(error: String) {
        errorView.configure(error: error)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
}
