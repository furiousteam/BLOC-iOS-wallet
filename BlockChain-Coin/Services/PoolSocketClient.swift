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
    // MARK: Properties
    
    fileprivate let url: URL
    fileprivate let socket: GCDAsyncSocket
    fileprivate let delegate = PoolSocketClientDelegate()
    
    // MARK: Pool methods
    
    init?(host: String, port: Int, walletAddress: String, password: String) {
        var c = URLComponents()
        c.scheme = "stratum+tcp"
        c.port = port
        c.user = walletAddress
        c.password = password

        guard let url = c.url else {
            return nil
        }
        
        self.url = url
        self.socket = GCDAsyncSocket(delegate: delegate, delegateQueue: .main)
    }
    
    func connect(completion: @escaping PoolStoreConnectCompletionHandler) {
        guard socket.isDisconnected else {
            completion(.failure(error: .alreadyConnected))
            return
        }
        
        guard let host = url.host, let port = url.port else {
            completion(.failure(error: .couldNotConnect))
            return
        }
        
        delegate.didConnect = {
            completion(.success(result: true))
        }

        do {
            try socket.connect(toHost: host, onPort: UInt16(port))
        } catch {
            completion(.failure(error: .couldNotConnect))
        }
    }
    
    func disconnect(completion: @escaping PoolStoreDisconnectCompletionHandler) {
        guard socket.isConnected else {
            completion(.failure(error: .alreadyDisconnected))
            return
        }
        
        delegate.didDisconnect = {
            completion(.success(result: true))
        }

        socket.disconnect()
    }
    
    func submit(job: JobModel, completion: @escaping PoolStoreSubmitJobCompletionHandler) {
        
    }
}
