//
//  PoolSocketClient.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class PoolSocketClient: PoolStore {
    public enum Tags: Int {
        case write = 1
        case read = 2
    }
    
    fileprivate let socket: GCDAsyncSocket
    fileprivate let delegate = PoolSocketClientDelegate()
    
    // MARK: Pool methods
    
    init() {
        self.socket = GCDAsyncSocket(delegate: delegate, delegateQueue: .main)
    }
    
    func connect(host: String, port: Int, completion: @escaping PoolStoreConnectCompletionHandler) {
        guard socket.isDisconnected else {
            completion(.failure(error: .alreadyConnected))
            return
        }
        
        delegate.connectionCallback = completion
        
        delegate.disconnectionCallback = { _  in
            completion(.failure(error: .couldNotConnect))
        }

        do {
            var poolHost = host
            
            if host.contains("http://") {
                poolHost = host.replacingOccurrences(of: "http://", with: "")
            } else if host.contains("https://") {
                poolHost = host.replacingOccurrences(of: "https://", with: "")
            }
            
            try socket.connect(toHost: poolHost, onPort: UInt16(port), withTimeout: TimeInterval(30.0))
        } catch let error {
            log.error(error)
            completion(.failure(error: .couldNotConnect))
        }
    }
    
    func disconnect(completion: @escaping PoolStoreDisconnectCompletionHandler) {
        guard socket.isConnected else {
            completion(.failure(error: .alreadyDisconnected))
            return
        }
        
        delegate.disconnectionCallback = completion
        
        socket.disconnect()
    }
    
    func login(username: String, password: String, completion: @escaping PoolStoreLoginCompletionHandler) {
        let request = PoolSocketLoginRequest(username: username, password: password)
        
        delegate.didWrite = { [weak self] in            
            guard let `self` = self else { return }
            
            self.receive()
        }
        
        delegate.loginCallback = completion
        
        send(request: request)
    }
    
    func submit(id: String, jobId: String, result: Data, nonce: UInt32, completion: @escaping PoolStoreSubmitJobCompletionHandler) {
        let request = PoolSocketSubmitJobRequest(id: id, jobId: jobId, result: result, nonce: nonce)
        
        delegate.submitJobCallback = completion
        
        send(request: request)
    }
    
    // MARK: Socket request
    
    func send(request: PoolSocketRequest) {
        guard let data = try? JSONEncoder().encode(request) else { return }
        
        let terminatedData = data + Data(bytes: [0x0A])
        
        socket.write(terminatedData, withTimeout: TimeInterval(30), tag: Tags.write.rawValue)
    }
    
    fileprivate func receive() {
        socket.readData(to: Data(bytes: [0x0A]), withTimeout: -1, tag: Tags.read.rawValue)
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
