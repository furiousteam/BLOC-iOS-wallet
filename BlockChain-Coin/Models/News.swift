//
//  News.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol NewsModel {
    var title: String { get }
    var description: String? { get }
    var date: Date { get }
    var url: URL { get }
}

struct News: NewsModel {
    let title: String
    let description: String?
    let date: Date
    let url: URL
}
