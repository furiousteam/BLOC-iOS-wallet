//
//  ArrayDataSource.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ArrayDataSource : NSObject {
    var items: [[Any]] = []
    var isLoading: Bool = false
    var errorText: String?
}

extension ArrayDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading || errorText != nil{
            return 1
        }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading || errorText != nil {
            return 1
        }
        
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseIdentifier(), for: indexPath) as! LoadingTableViewCell
            
            cell.loadingView.startAnimating()
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            
            return cell
        }
        
        if let errorText = errorText {
            let cell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.reuseIdentifier(), for: indexPath) as! ErrorTableViewCell
            
            cell.configure(error: errorText)
            
            return cell
        }

        fatalError("Must be implemented by subclass")
    }
}

extension ArrayDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Must be implemented by subclass")
    }
}

