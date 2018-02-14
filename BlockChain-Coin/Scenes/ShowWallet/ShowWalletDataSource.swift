//
//  ShowWalletDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowWalletDataSource: NSObject, UITableViewDataSource {
    
    var wallet: Wallet? = nil
    var balances: [BalanceModel] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // TODO
            return 0
        } else if section == 1 {
            return balances.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletBalanceCell.reuseIdentifier(), for: indexPath) as! ShowWalletBalanceCell
            
            let balance = balances[indexPath.row]
            
            cell.configure(balance: balance.value, subtitle: balance.balanceType.name)
            
            return cell
        //}
    }
    
}

