//
//  PoolSocketSubmitJobRequest.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 09/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation
import NSData_FastHex

protocol PoolSocketSubmitJobRequestModel {
    var id: String { get }
    var jobId: String { get }
    var result: Data { get }
    var nonce: UInt32 { get }
}

class PoolSocketSubmitJobRequest: PoolSocketRequest, PoolSocketSubmitJobRequestModel {
    let id: String
    let jobId: String
    let result: Data
    let nonce: UInt32
    
    enum CodingKeys: String, CodingKey {
        case method = "method"
        case tag = "id"
        case params = "params"
    }
    
    enum JobCodingKeys: String, CodingKey {
        case id = "id"
        case jobId = "job_id"
        case result = "result"
        case nonce = "nonce"
    }
    
    init(id: String, jobId: String, result: Data, nonce: UInt32) {
        self.id = id
        self.jobId = jobId
        self.result = result
        self.nonce = nonce
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("submit", forKey: .method)
        try container.encode(1, forKey: .tag)
        
        var jobInfos = container.nestedContainer(keyedBy: JobCodingKeys.self, forKey: .params)
        try jobInfos.encode(id, forKey: .id)
        try jobInfos.encode(jobId, forKey: .jobId)
        try jobInfos.encode((result as NSData).hexStringRepresentationUppercase(false), forKey: .result)
        
        var nonceData = Data(count:  MemoryLayout<UInt32>.size)
        
        nonceData.withUnsafeMutableBytes { (ptr: UnsafeMutablePointer<UInt32>) -> Void in
            ptr.pointee = nonce
        }
        
        try jobInfos.encode((nonceData as NSData).hexStringRepresentationUppercase(false), forKey: .nonce)
    }
}
