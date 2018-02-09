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
        case result = "result"
    }
    
    enum ResultCodingKeys: String, CodingKey {
        case id = "id"
        case job = "job"
    }

    init(id: UInt64, job: Job) {
        self.id = id
        self.job = job
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(UInt64.self, forKey: .id)
        
        let resultValues = try values.nestedContainer(keyedBy: ResultCodingKeys.self, forKey: .result)
        
        job = try resultValues.decode(Job.self, forKey: .job)
        job.id = try resultValues.decode(String.self, forKey: .id)
    }
}

