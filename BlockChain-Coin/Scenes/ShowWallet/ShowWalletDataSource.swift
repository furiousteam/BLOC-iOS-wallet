//
//  ShowWalletDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ShowWalletDataSource: ArrayDataSource {
    
    var didTapCopy: () -> Void = { }
    var didTapQRCode: () -> Void = { }
    var didTapFullHistory: () -> Void = { }
    var didTapCoinGecko: () -> Void = { }
    var didTapCurrency: (String) -> Void = { _ in }

    var wallet: WalletModel? = nil
    var balances: [BalanceModel] = []
    var transactions: [TransactionModel] = []
    var blocValue: Double? = nil
    var priceChange24Hours: Double? = nil
    var currency: String? = nil

    enum Section: Int {
        case balance
        case export
        case value
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
        } else if section == Section.value.rawValue {
            return blocValue == nil ? 0 : 1
        } else if section == Section.transactionHeader.rawValue {
            return transactions.isEmpty ? 0 : 1
        } else {
            return transactions.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading || errorText != nil {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        let availableBalance = balances.first(where: { $0.balanceType == .available })?.value ?? 0.0
        let lockedBalance = balances.first(where: { $0.balanceType == .locked })?.value ?? 0.0

        if indexPath.section == Section.balance.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletBalanceCell.reuseIdentifier(), for: indexPath) as! ShowWalletBalanceCell
            
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
        } else if indexPath.section == Section.value.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletValueCell.reuseIdentifier(), for: indexPath) as! ShowWalletValueCell

            
            if let blocValue = blocValue {
                let totalBalance = (availableBalance + lockedBalance)

                cell.configure(blocValue: blocValue, totalValue: totalBalance * blocValue, evolution: priceChange24Hours ?? 0.0, selectedCurrency: currency ?? "USD")
            }
            
            cell.didTapCoinGecko = { self.didTapCoinGecko() }
            cell.didTapCurrency = { self.didTapCurrency($0) }
                        
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

