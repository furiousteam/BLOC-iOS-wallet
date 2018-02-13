//
//  CreateWalletDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class CreateWalletDataSource: NSObject, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateWalletCell.reuseIdentifier(), for: indexPath) as! CreateWalletCell
        
        if indexPath.row == 0 {
            cell.configure(title: "Create a new wallet")
        } else if indexPath.row == 1 {
            cell.configure(title: "Restore a wallet from a mnemonic seed")
        }
        
        return cell
    }
    
}
