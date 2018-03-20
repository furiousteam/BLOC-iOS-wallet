//
//  ShowWalletDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowWalletDataSource: NSObject, UITableViewDataSource {
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.balance.rawValue {
            return balances.isEmpty ? 0 : 1
        } else if section == Section.export.rawValue {
            return wallet == nil ? 0 : 1
        } else if section == Section.transactionHeader.rawValue {
            return transactions.isEmpty ? 0 : 1
        } else {
            return transactions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.balance.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletBalanceCell.reuseIdentifier(), for: indexPath) as! ShowWalletBalanceCell
            
            return cell
        } else if indexPath.section == Section.export.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletExportKeysCell.reuseIdentifier(), for: indexPath) as! ShowWalletExportKeysCell
            
            return cell
        } else if indexPath.section == Section.transactionHeader.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletTransactionsHeaderCell.reuseIdentifier(), for: indexPath) as! ShowWalletTransactionsHeaderCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletTransactionCell.reuseIdentifier(), for: indexPath) as! ShowWalletTransactionCell
            
            return cell
        }
    }
    
}

