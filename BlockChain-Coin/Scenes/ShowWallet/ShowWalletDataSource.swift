//
//  ShowWalletDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowWalletDataSource: ArrayDataSource {
    
    var didTapCopy: () -> Void = { }
    var didTapQRCode: () -> Void = { }
    var didTapFullHistory: () -> Void = { }

    var wallet: WalletModel? = nil
    var balances: [BalanceModel] = []
    var transactions: [TransactionModel] = []

    enum Section: Int {
        case balance
        case export
        case transactionHeader
        case transactions
        case count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading || errorText != nil {
            return super.numberOfSections(in: tableView)
        }
        
        return Section.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading || errorText != nil {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
        if section == Section.balance.rawValue {
            return balances.isEmpty ? 0 : 1
        } else if section == Section.export.rawValue {
            return wallet == nil ? 0 : 1
        } else if section == Section.transactionHeader.rawValue {
            return wallet == nil ? 0 : 1
        } else {
            return transactions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading || errorText != nil {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }

        if indexPath.section == Section.balance.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletBalanceCell.reuseIdentifier(), for: indexPath) as! ShowWalletBalanceCell
            
            let availableBalance = balances.first(where: { $0.balanceType == .available })?.value ?? 0.0
            let lockedBalance = balances.first(where: { $0.balanceType == .locked })?.value ?? 0.0

            cell.configure(availableBalance: availableBalance, lockedBalance: lockedBalance)
            
            return cell
        } else if indexPath.section == Section.export.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletExportKeysCell.reuseIdentifier(), for: indexPath) as! ShowWalletExportKeysCell
            
            if let wallet = wallet {
                cell.configure(address: wallet.address)
                
                cell.didTapCopy = { self.didTapCopy() }
                cell.didTapQRCode = { self.didTapQRCode() }
            }
            
            return cell
        } else if indexPath.section == Section.transactionHeader.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletTransactionsHeaderCell.reuseIdentifier(), for: indexPath) as! ShowWalletTransactionsHeaderCell
            
            cell.didTapFullHistory = { self.didTapFullHistory() }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletTransactionCell.reuseIdentifier(), for: indexPath) as! ShowWalletTransactionCell
            
            cell.configure(transaction: transactions[indexPath.row])
            
            return cell
        }
    }
    
}

