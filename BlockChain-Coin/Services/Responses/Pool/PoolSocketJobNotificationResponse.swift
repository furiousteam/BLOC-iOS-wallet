//
//  PoolSocketJobNotificationResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 09/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol PoolSocketJobNotificationResponseModel {
    var method: String { get }
    var job: Job { get }
}

class PoolSocketJobNotificationResponse: PoolSocketJobNotificationResponseModel, Decodable {
    let method: String
    let job: Job
    
    enum CodingKeys: String, CodingKey {
        case method = "method"
        case job = "params"
    }
        
    init(method: String, job: Job) {
        self.method = method
        self.job = job
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        method = try values.decode(String.self, forKey: .method)
        job = try values.decode(Job.self, forKey: .job)
    }
}
