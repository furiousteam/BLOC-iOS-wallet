//
//  ActionCell.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ActionCell: TableViewCell {
    
    let button = ActionButton()

    override func commonInit() {
        super.commonInit()
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(button)
        
        button.isUserInteractionEnabled = false
        
        button.snp.makeConstraints({
            let percent = UIScreen.main.bounds.width * 0.15
            $0.leading.trailing.equalToSuperview().inset(percent)
            $0.top.bottom.equalToSuperview().inset(15.0)
            $0.center.equalToSuperview()
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
    func configure(title: String) {
        button.setTitle(title, for: .normal)
    }

}
