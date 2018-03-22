//
//  CollectionViewCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 21/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    var shouldSetupConstraints: Bool = true
    
    init() {
        super.init(frame: .zero)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard shouldSetupConstraints else { return }
        
        createConstraints()
        
        shouldSetupConstraints = false
    }
    
    func createConstraints() {
        
    }
}
