//
//  WalletSocketClient.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 10/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

import Foundation
import CocoaAsyncSocket

class WalletSocketClient: WalletStore {
    public enum Tags: Int {
        case write = 1
        case read = 2
    }
    
    fileprivate let socket: GCDAsyncSocket!
    fileprivate let socketDelegate: WalletSocketClientDelegate
    
    weak var delegate: WalletStoreDelegate?
    
    // MARK: - Pool methods
    
    init(delegate: WalletStoreDelegate?) {
        self.socketDelegate = WalletSocketClientDelegate(delegate: delegate)
        self.socket = GCDAsyncSocket(delegate: socketDelegate, delegateQueue: .main)
        self.delegate = delegate
    }
    
    func connect(host: String, port: Int) {
        guard socket.isDisconnected else {
            delegate?.walletStoreDidFailToConnect(error: .alreadyConnected)
            return
        }
        
        do {
            try socket.connect(toHost: host, onPort: UInt16(port), withTimeout: TimeInterval(30.0))
        } catch let error {
            print(error)
            delegate?.walletStoreDidFailToConnect(error: .couldNotConnect)
        }
    }
    
    func disconnect() {
        guard socket.isConnected else {
            delegate?.walletStoreDidFailToDisconnectDisconnect(error: .alreadyDisconnected)
            return
        }
        
        socket.disconnect()
    }
    
    // MARK: - Ignored methods
    
    func generateSeed() -> Seed? {
        return nil
    }
    
    func generateKeyPair(seed: Seed) -> KeyPair? {
        return nil
    }
        
    // MARK: - Socket request
    
    func send(request: WalletSocketRequest) {
        guard let data = try? JSONEncoder().encode(request) else { return }
        
        let terminatedData = data + Data(bytes: [0x0A])
        
        socket.write(terminatedData, withTimeout: TimeInterval(30), tag: Tags.write.rawValue)
    }
    
    fileprivate func receive() {
        socket.readData(to: Data(bytes: [0x0A]), withTimeout: -1, tag: Tags.read.rawValue)
    }
}
