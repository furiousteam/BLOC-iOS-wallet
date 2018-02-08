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
    var didConnect: () -> Void = { }
    var didDisconnect: () -> Void = { }
    var didReadJob: (JobModel) -> Void = { _ in }
    var didFailToRead: (Data) -> Void = { _ in }
    var didWrite: () -> Void = { }

    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
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
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        switch tag {
        case PoolSocketClient.Tags.write.rawValue:
            didWrite()
        default:
            break
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        switch tag {
        case PoolSocketClient.Tags.read.rawValue:
            if let jobResponse = try? JSONDecoder().decode(PoolSocketJobResponse.self, from: data) {
                didReadJob(jobResponse.job)
            } else {
                didFailToRead(data)
            }
        default:
            break
        }
    }
}
