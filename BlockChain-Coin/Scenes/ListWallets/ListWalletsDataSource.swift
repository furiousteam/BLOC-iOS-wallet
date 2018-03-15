//
//  ListWalletsDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ListWalletsDataSource: NSObject, UITableViewDataSource {
    
    var wallets: [WalletModel] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return wallets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListWalletsCell.reuseIdentifier(), for: indexPath) as! ListWalletsCell
        
        let wallet = wallets[indexPath.section]
        
        cell.configure(name: R.string.localizable.wallet_list_item_title(indexPath.section + 1), balance: 10.000896876)
        
        return cell
    }
    
}
