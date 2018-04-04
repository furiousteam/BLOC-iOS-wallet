//  
//  WalletSettingsDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class WalletSettingsDataSource: ArrayDataSource {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletSettingsCell.reuseIdentifier(), for: indexPath) as! WalletSettingsCell
        
        if indexPath.row == 0 {
            cell.configure(image: R.image.settings_export()!, title: R.string.localizable.wallet_settings_backup())
        } else if indexPath.row == 1 {
            cell.configure(image: R.image.settings_delete()!, title: R.string.localizable.wallet_settings_delete())
        }
        
        return cell
    }
    
}
