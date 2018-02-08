//
//  PoolSocketClientDelegate.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class PoolSocketClientDelegate: NSObject, GCDAsyncSocketDelegate {
    enum Tags: Int {
        case send = 1
        case read = 2
    }

    var didConnect: () -> Void = { }
    var didDisconnect: () -> Void = { }
    var didRead: (Data) -> Void = { _ in }
    
    func socket(_ sock: GCDAsyncSocket, didConnectTo url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.didConnect()
        }
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.didDisconnect()
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        switch tag {
        case Tags.read.rawValue:
            didRead(data)
        default:
            break
        }
    }
}
