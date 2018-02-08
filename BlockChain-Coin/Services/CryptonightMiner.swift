//
//  CryptonightMiner.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

class CryptonightMiner: MinerStore {
    func start(threadCount: Int, completion: @escaping MinerStoreStartCompletionHandler) {
        
    }
    
    func stop(completion: @escaping MinerStoreStopCompletionHandler) {
        
    }
    
    func evaluate(job: JobModel, hash: Data, completion: @escaping MinerStoreEvaluateCompletionHandler) {
        let start = 24
        let sd = hash.subdata(in: start ..< start + MemoryLayout<UInt64>.size)
        let v = sd.withUnsafeBytes { (a: UnsafePointer<UInt64>) -> UInt64 in a.pointee }
        let result = v < job.target
        
        completion(.success(result: result))
    }
}
