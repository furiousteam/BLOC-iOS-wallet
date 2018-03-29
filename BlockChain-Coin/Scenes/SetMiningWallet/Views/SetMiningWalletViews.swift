//
//  SetMiningWalletViews.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import CenterAlignedCollectionViewFlowLayout

class SetMiningWalletViews: NSObject {
    let orderedViews: [UIView]
        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.mining_select_wallet_title()
        label.font = .regular(size: 12.5)
        label.textColor = UIColor.white.withAlphaComponent(0.75)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = CenterAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    // Action
    override init() {
        NewTransactionWalletCell.registerWith(collectionView)
        NewTransactionNoWalletCell.registerWith(collectionView)
        
        collectionView.snp.makeConstraints({
            $0.height.equalTo(0.0)
        })
        
        orderedViews = [ SpacerView(height: 15.0),
                         titleLabel,
                         SpacerView(height: 25.0),
                         collectionView ]
        
        super.init()
    }
        
}
