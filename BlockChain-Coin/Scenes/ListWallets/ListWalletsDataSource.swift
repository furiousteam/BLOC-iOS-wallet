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
        if wallets.count == 0 {
            return 3
        }
        
        return wallets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if wallets.count == 0 {
            switch section {
            case 0, 1:
                return 1
            case 2:
                return 3
            default:
                return 0
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if wallets.count == 0 {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoWalletTitleCell.reuseIdentifier(), for: indexPath) as! NoWalletTitleCell
                cell.configure(title: R.string.localizable.wallet_list_no_wallet_title())
                return cell
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoWalletInstructionsCell.reuseIdentifier(), for: indexPath) as! NoWalletInstructionsCell
                cell.configure(title: R.string.localizable.wallet_list_no_wallet_instructions())
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ActionCell.reuseIdentifier(), for: indexPath) as! ActionCell
                
                if indexPath.row == 0 {
                    cell.configure(title: R.string.localizable.wallet_list_no_wallet_create())
                } else if indexPath.row == 1 {
                    cell.configure(title: R.string.localizable.wallet_list_no_wallet_import_key())
                } else if indexPath.row == 2 {
                    cell.configure(title: R.string.localizable.wallet_list_no_wallet_import_qr_code())
                }
                
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListWalletsCell.reuseIdentifier(), for: indexPath) as! ListWalletsCell
        
        let wallet = wallets[indexPath.section]
        
        let totalBalance = ((wallet.details?.availableBalance ?? 0.0) + (wallet.details?.lockedBalance ?? 0.0)) / Constants.walletCurrencyDivider
        
        cell.configure(name: R.string.localizable.wallet_list_item_title(indexPath.section + 1), balance: totalBalance)
        
        return cell
    }
    
}
