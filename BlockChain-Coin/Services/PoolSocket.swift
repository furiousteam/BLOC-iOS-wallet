//
//  PoolSocket.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import APIKit
import JSONRPCKit

struct PoolSocketRPCRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch
    let pool: MiningPoolModel
    
    typealias Response = Batch.Responses
    
    var baseURL: URL {
        var poolHost = pool.host
        
        /*if poolHost.contains("http://") {
            poolHost = poolHost.replacingOccurrences(of: "http://", with: "")
        } else if poolHost.contains("https://") {
            poolHost = poolHost.replacingOccurrences(of: "https://", with: "")
        }*/
        
        /*if !poolHost.contains("stratum+tcp://") {
            poolHost = "stratum+tcp://\(poolHost)"
        }*/
        
        return URL(string: "\(poolHost):\(pool.port)")!
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/"
    }
    
    var parameters: Any? {
        return batch.requestObject
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
    }
}

struct CastError<ExpectedType>: Error {
    let actualValue: Any
    let expectedType: ExpectedType.Type
}

struct LoginRequest: JSONRPCKit.Request {
    typealias Response = JobModel
    
    let address: String
    let password: String
    let pool: MiningPoolModel
    
    var method: String {
        return "login"
    }
    
    var parameters: Any? {
        return [ "login": address, "password": password ]
    }
    
    func response(from resultObject: Any) throws -> Response {
        if let response = resultObject as? Response {
            return response
        } else {
            throw CastError(actualValue: resultObject, expectedType: Response.self)
        }
    }
}

public struct StringIdGenerator: IdGenerator {
    
    private var currentId = 1
    
    public mutating func next() -> Id {
        defer {
            currentId += 1
        }
        
        return .string("id\(currentId)")
    }
}

class PoolSocket: PoolStore {
    let batchFactory = BatchFactory(idGenerator: StringIdGenerator())
    
    var isConnected: Bool = false
    
    let pool: MiningPoolModel
    
    // MARK: Pool methods

    init(pool: MiningPoolModel) {
        self.pool = pool
    }
    
    func connect(host: String, port: Int, completion: @escaping PoolStoreConnectCompletionHandler) {
        /*guard !isConnected else {
            completion(.failure(error: .alreadyConnected))
            return
        }

        switch client.connect(timeout: 10) {
        case .success:
            log.info("Connected to \(client.address)")
            self.isConnected = true
            completion(.success(result: true))
        case .failure(let error):
            log.error("Could not connect to \(client.address) : \(error)")
            self.isConnected = false
            completion(.failure(error: .couldNotConnect))
        }*/
        
        self.isConnected = true
        completion(.success(result: true))
    }
    
    func disconnect(completion: @escaping PoolStoreDisconnectCompletionHandler) {
        guard isConnected else {
            completion(.failure(error: .alreadyDisconnected))
            return
        }
        
        //client.close()
        
        completion(.success(result: true))
    }
    
    func login(username: String, password: String, completion: @escaping PoolStoreLoginCompletionHandler) {
        let loginRequest = LoginRequest(address: username, password: password, pool: pool)
        
        let batch = batchFactory.create(loginRequest)
        let httpRequest = PoolSocketRPCRequest(batch: batch, pool: pool)
        
        Session.send(httpRequest) { result in
            switch result {
            case .success(let job):
                completion(.success(result: job))
            case .failure(let error):
                log.error(error)
                completion(.failure(error: .couldNotConnect))
            }
        }
    }
    
    func submit(id: String, jobId: String, result: Data, nonce: UInt32, completion: @escaping PoolStoreSubmitJobCompletionHandler) {
        /*let request = PoolSocketSubmitJobRequest(id: id, jobId: jobId, result: result, nonce: nonce)
        
        delegate.submitJobCallback = completion
        
        send(request: request)*/
    }
    
    // MARK: Ignored requests
    
    func stats(pool: MiningPoolModel, completion: @escaping PoolStoreStatsCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func stats(pools: [MiningPoolModel], completion: @escaping PoolStoreStatsMultipleCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func listPools(completion: @escaping PoolStoreListCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func addPool(pool: MiningPool) {
        return
    }
    
    func addressStats(pool: MiningPoolModel, address: String, completion: @escaping PoolStoreAddressStatsCompletionHandler) {
        completion(.failure(error: .unknown))
    }
}
