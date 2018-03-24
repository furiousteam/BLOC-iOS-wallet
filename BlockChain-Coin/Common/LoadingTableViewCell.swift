//
//  LoadingTableViewCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 24/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class LoadingTableViewCell: TableViewCell {
    
    let loadingView = LoadingView()
    
    // MARK: - View lifecycle
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(loadingView)
        
        loadingView.startAnimating()
        
        loadingView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
}
