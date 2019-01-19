//
//  UITableViewHeaderFooterView+Register.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

extension UITableViewHeaderFooterView: Reusable {
    static func registerWith(_ tableView: UITableView) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: self.reuseIdentifier())
    }
}
