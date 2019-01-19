//  
//  ListNewsRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ListNewsRoutingLogic {
    func showHome()
    func showNews(news: NewsModel)
}

class ListNewsRouter: Router, ListNewsRoutingLogic {
    weak var viewController: UIViewController?
    
    func showHome() {
        NotificationCenter.default.post(name: .selectMenuTab, object: nil)
    }
    
    func showNews(news: NewsModel) {
        UIApplication.shared.open(news.url, options: [:], completionHandler: nil)
    }
}

