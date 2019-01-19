//
//  View.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 09/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class View: UIView {
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    var shouldSetupConstraints: Bool = true
    
    init() {
        super.init(frame: .zero)
        
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
