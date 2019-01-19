//
//  NewsRSSFeed.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation
import FeedKit

class NewsRSSFeed: NewsStore {
    private var parser: FeedParser?
    
    func listNews(completion: @escaping NewsStoreListCompletionHandler) {
        let feedURL = URL(string: "https://medium.com/feed/@bloc.money")!
        self.parser = FeedParser(URL: feedURL)
        
        guard let parser = self.parser else {
            completion(.failure(error: .unknown))
            return
        }
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            switch result {
            case let .rss(feed):
                let news: [News] = feed.items?.compactMap({ item -> News? in
                    guard let title = item.title, let urlString = item.link, let url = URL(string: urlString), let date = item.pubDate else { return nil }
                    
                    return News(title: title, description: item.description, date: date, url: url)
                }) ?? []
                
                completion(.success(result: news))
            case let .failure(error):
                log.error(error)
                completion(.failure(error: .unknown))
            default:
                completion(.failure(error: .unknown))
            }
            
        }
    }
}
