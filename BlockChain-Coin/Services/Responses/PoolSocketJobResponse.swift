//
//  PoolSocketJobResponse.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol PoolSocketJobResponseModel {
    var id: UInt64 { get }
    var job: Job { get }
}

class PoolSocketJobResponse: PoolSocketJobResponseModel, Decodable {
    let id: UInt64
    let job: Job
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case job = "result"
    }
    
    init(id: UInt64, job: Job) {
        self.id = id
        self.job = job
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(UInt64.self, forKey: .id)
        job = try values.decode(Job.self, forKey: .job)
    }
}

