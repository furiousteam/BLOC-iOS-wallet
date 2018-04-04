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
    var didTapStats: () -> Void = { }

    var settings: MiningSettingsModel?
    
    var hashRate: Double = 0.0
    var totalHashes: UInt = 0
    var sharesFound: UInt = 0
    var activeMiners: UInt = 0
    var pendingBalance: Double = 0
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = settings else {
            return 3
        }
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = settings else {
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
        if settings == nil {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoWalletTitleCell.reuseIdentifier(), for: indexPath) as! NoWalletTitleCell
                cell.configure(title: R.string.localizable.mining_no_wallet())
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

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MiningBootCell.reuseIdentifier(), for: indexPath) as! MiningBootCell
            
            cell.didChangeSwitch = didChangeSwitch
            
            cell.statsView.configure(hashRate: hashRate, pendingBalance: pendingBalance, activeMiners: activeMiners)
            
            cell.statsButton.didTapStats = didTapStats
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MineSettingsCell.reuseIdentifier(), for: indexPath) as! MineSettingsCell
        
        switch indexPath.section {
        case 1:
            cell.configure(title: R.string.localizable.mining_number_of_threads_title(), value: "\(settings!.power.readableString) (\(settings!.threads))")
        case 2:
            cell.configure(title: R.string.localizable.mining_mining_pool_title(), value: settings!.pool.host)
        case 3:
            let balance = (((settings!.wallet.details?.availableBalance ?? 0.0) + (settings!.wallet.details?.lockedBalance ?? 0.0)) / Constants.walletCurrencyDivider).blocCurrency()
            cell.configure(title: R.string.localizable.mining_wallet_title(settings!.wallet.name), value: R.string.localizable.mining_wallet_value(balance))
        default:
            break
        }
        
        return cell
    }
    
}
