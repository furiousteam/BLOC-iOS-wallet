//  
//  ListTransactionsDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ListTransactionsDataSource: ArrayDataSource {
    var transactions: [ListTransactionItemViewModel] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading || errorText != nil {
            return super.numberOfSections(in: tableView)
        }
        
        if transactions.count == 0 {
            return 1
        }
        
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading || errorText != nil {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }

        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading || errorText != nil {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        if transactions.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: NoTransactionsCell.reuseIdentifier(), for: indexPath) as! NoTransactionsCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTransactionsCell.reuseIdentifier(), for: indexPath) as! ListTransactionsCell
        
        let backgroundColor = (indexPath.section % 2 == 0 ? UIColor(hex: 0x0d234c) : UIColor(hex: 0x00153e))
        
        cell.configure(transaction: transactions[indexPath.section], backgroundColor: backgroundColor)
        
        return cell
    }

}
