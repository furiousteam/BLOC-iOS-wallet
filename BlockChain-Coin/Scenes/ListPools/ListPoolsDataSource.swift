//  
//  ListPoolsDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ListPoolsDataSource: ArrayDataSource {
    var pools: [MiningPoolModel] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading || errorText != nil {
            return super.numberOfSections(in: tableView)
        }
        
        return pools.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListPoolsCell.reuseIdentifier(), for: indexPath) as! ListPoolsCell
        
        let pool = pools[indexPath.section]
        
        cell.configure(name: "\(pool.host)", subtitle: pool.stats?.shortDescription ?? "")
        
        return cell
    }

}
