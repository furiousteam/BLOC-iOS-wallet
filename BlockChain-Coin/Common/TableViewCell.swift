//
//  TableViewCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    var shouldSetupConstraints: Bool = true
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func commonInit() {
        
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

