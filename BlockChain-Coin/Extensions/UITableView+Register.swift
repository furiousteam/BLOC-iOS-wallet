//
//  UITableView+Register.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

extension UITableViewCell: Reusable {
    static func registerWith(_ tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: self.reuseIdentifier())
    }
}
