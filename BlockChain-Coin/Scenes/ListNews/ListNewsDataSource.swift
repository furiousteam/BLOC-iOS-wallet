//  
//  ListNewsDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ListNewsDataSource: ArrayDataSource {
    var news: [NewsModel] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading || errorText != nil {
            return super.numberOfSections(in: tableView)
        }
        
        return news.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListNewsCell.reuseIdentifier(), for: indexPath) as! ListNewsCell
        
        cell.configure(news: news[indexPath.section])
        
        return cell
    }
}
