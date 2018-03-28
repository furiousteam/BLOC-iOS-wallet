//
//  MineDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MineDataSource: NSObject, UITableViewDataSource {
    
    var didChangeSwitch: (Bool) -> Void = { _ in }

    var settings: MiningSettingsModel?
    
    var hashRate: Double = 0.0
    var totalHashes: UInt = 0
    var sharesFound: UInt = 0
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = settings else { return 0 }
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MiningBootCell.reuseIdentifier(), for: indexPath) as! MiningBootCell
            
            cell.didChangeSwitch = didChangeSwitch
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MineSettingsCell.reuseIdentifier(), for: indexPath) as! MineSettingsCell
        
        switch indexPath.section {
        case 1:
            cell.configure(title: R.string.localizable.mining_number_of_threads_title(), value: settings!.power.readableString)
        case 2:
            cell.configure(title: R.string.localizable.mining_mining_pool_title(), value: settings!.pool.url.absoluteString)
        case 3:
            let balance = (((settings!.wallet.details?.availableBalance ?? 0.0) + (settings!.wallet.details?.lockedBalance ?? 0.0)) / Constants.walletCurrencyDivider).blocCurrency()
            cell.configure(title: R.string.localizable.mining_wallet_title(settings!.wallet.name), value: R.string.localizable.mining_wallet_value(balance))
        default:
            break
        }
        
        return cell
    }
    
}
