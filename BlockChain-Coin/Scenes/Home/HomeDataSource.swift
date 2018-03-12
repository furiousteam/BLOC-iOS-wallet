//  
//  HomeDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class HomeDataSource: ArrayDataSource {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.reuseIdentifier(), for: indexPath) as! HomeCell
        
        if let item = (items[indexPath.section][indexPath.row] as? HomeItem) {
            cell.configure(for: item)
        }
        
        return cell
    }
    
}
