//
//  PoolSocketClient.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

protocol PoolSocketDelegate: class {
    func didConnect(toHost host: String)
    func didDisconnect(error: Error?)
    func didReceiveJob(job: JobModel)
    func didSendJob()
    func didFailWithError(error: PoolStoreError)
}

class PoolSocketClient: PoolStore {
    public enum Tags: Int {
        case write = 1
        case read = 2
    }
    
    fileprivate let socket: GCDAsyncSocket
    fileprivate let delegate = PoolSocketClientDelegate()
    weak var clientDelegate: PoolSocketDelegate?
    
    // MARK: Pool methods
    
    init(delegate clientDelegate: PoolSocketDelegate) {
        self.socket = GCDAsyncSocket(delegate: delegate, delegateQueue: .main)
        self.clientDelegate = clientDelegate
        self.delegate.delegate = self.clientDelegate
    }
    
    func connect(host: String, port: Int, completion: @escaping PoolStoreConnectCompletionHandler) {
        guard socket.isDisconnected else {
            clientDelegate?.didFailWithError(error: .alreadyConnected)
            return
        }
        
        do {
            var poolHost = host
            
            if host.contains("http://") {
                poolHost = host.replacingOccurrences(of: "http://", with: "")
            } else if host.contains("https://") {
                poolHost = host.replacingOccurrences(of: "https://", with: "")
            }
            
            try socket.connect(toHost: poolHost, onPort: UInt16(port), withTimeout: TimeInterval(30.0))
            
            self.receive()
        } catch let error {
            log.error(error)
            clientDelegate?.didFailWithError(error: .couldNotConnect)
        }
    }
    
    func disconnect(completion: @escaping PoolStoreDisconnectCompletionHandler) {
        guard socket.isConnected else {
            clientDelegate?.didFailWithError(error: .alreadyDisconnected)
            return
        }
        
        socket.disconnect()
    }
    
    func login(username: String, password: String, completion: @escaping PoolStoreLoginCompletionHandler) {
        let request = PoolSocketLoginRequest(username: username, password: password)
        
        delegate.prepareReceive = { [weak self] in
            guard let `self` = self else { return }
            
            self.receive()
        }

        send(request: request)
    }
    
    func submit(id: String, jobId: String, result: Data, nonce: UInt32, completion: @escaping PoolStoreSubmitJobCompletionHandler) {
        let request = PoolSocketSubmitJobRequest(id: id, jobId: jobId, result: result, nonce: nonce)
        
        send(request: request)
    }
    
    // MARK: Socket request
    
    func send(request: PoolSocketRequest) {
        guard let data = try? JSONEncoder().encode(request) else { return }
        
        let terminatedData = data + Data(bytes: [0x0A])
        
        log.info(String(data: terminatedData, encoding: .utf8))

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
