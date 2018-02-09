//
//  MineDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MineDataSource: NSObject, UITableViewDataSource {
    
    var hashRate: Double = 0.0
    var totalHashes: UInt = 0
    var sharesFound: UInt = 0
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MineStatCell.reuseIdentifier(), for: indexPath) as! MineStatCell
        
        switch indexPath.section {
        case 0:
            cell.configure(title: "Hash Rate / s", value: "\(hashRate)")
        case 1:
            cell.configure(title: "Total Hashes", value: "\(totalHashes)")
        case 2:
            cell.configure(title: "Shares Found", value: "\(sharesFound)")
        default:
            break
        }
        
        return cell
    }
    
}
