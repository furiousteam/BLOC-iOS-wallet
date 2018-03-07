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
    var transactions: [TransactionModel] = []

    func numberOfSections(in tableView: UITableView) -> Int {
        return balances.count + transactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        else if section < balances.count {
            return 1
        } else {
            let transaction = transactions[section - balances.count]
            return 8 + transaction.transfers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < balances.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletCell.reuseIdentifier(), for: indexPath) as! ShowWalletCell
            
            let balance = balances[indexPath.section]
            
            cell.configure(title: "\(balance.value)", subtitle: balance.balanceType.name)
            
            return cell
        }
        else {
            let transaction = transactions[indexPath.section - balances.count]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ShowWalletCell.reuseIdentifier(), for: indexPath) as! ShowWalletCell
            
            switch indexPath.row {
            case 0:
                cell.configure(title: transaction.hash, subtitle: "Transaction Hash")
            case 1:
                cell.configure(title: "\(transaction.blockIndex)", subtitle: "Block Index")
            case 2:
                cell.configure(title: transaction.createdAt.shortDate(), subtitle: "Date")
            case 3:
                cell.configure(title: "\(transaction.unlockHeight)", subtitle: "Unlock Height")
            case 4:
                cell.configure(title: "\(transaction.amount)", subtitle: "Amount")
            case 5:
                cell.configure(title: "\(transaction.fee)", subtitle: "Fee")
            case 6:
                cell.configure(title: transaction.extra, subtitle: "Extra")
            case 7:
                cell.configure(title: transaction.paymentId, subtitle: "Payment ID")
            default:
                let transfer = transaction.transfers[indexPath.row - 8]
                cell.configure(title: "\(transfer.amount)", subtitle: transfer.address)
            }
            
            return cell
        }
    }
    
}

