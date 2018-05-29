//  
//  ListNewsModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct ListNewsViewModel {
    enum State {
        case loading
        case loaded([NewsModel])
        case error(String)
    }
    
    let state: State
    let news: [NewsModel]
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let news):
            self.news = news
        default:
            self.news = []
        }
    }
}

struct ListNewsRequest {

}
