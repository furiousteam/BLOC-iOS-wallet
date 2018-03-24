//  
//  ListTransactionsDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ListTransactionsDataSource: ArrayDataSource {
    var transactions: [ListTransactionItemViewModel] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if transactions.count == 0 {
            return 1
        }
        
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if transactions.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: ListTransactionsEmptyCell.reuseIdentifier(), for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTransactionsCell.reuseIdentifier(), for: indexPath) as! ListTransactionsCell
                
        cell.configure(transaction: transactions[indexPath.section])
        
        return cell
    }

}
