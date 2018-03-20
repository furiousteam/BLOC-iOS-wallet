//
//  ShowWalletDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowWalletDataSource: NSObject, UITableViewDataSource {
    
    var didTapCopy: () -> Void = { }
    var didTapQRCode: () -> Void = { }

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
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletTransactionCell.reuseIdentifier(), for: indexPath) as! ShowWalletTransactionCell
            
            return cell
        }
    }
    
}

