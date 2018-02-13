//
//  WalletSocketClientDelegate.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 10/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class WalletSocketClientDelegate: NSObject, GCDAsyncSocketDelegate {
    weak var delegate: WalletStoreDelegate?
    
    init(delegate: WalletStoreDelegate?) {
        self.delegate = delegate
        
        super.init()
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        delegate?.walletStoreDidConnect()
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print(err)
        delegate?.walletStoreDidDisconnect()
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        switch tag {
        case PoolSocketClient.Tags.write.rawValue:
            print("Wallet socket did write data")
        default:
            break
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        switch tag {
        case PoolSocketClient.Tags.read.rawValue:
            if let _ = try? JSONDecoder().decode(WalletSocketAddResponse.self, from: data) {
                delegate?.walletStoreDidAddWallet()
            }
            else if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any] {
                delegate?.walletStore(didReceiveUnknownResponse: json)
            } else {
                print("Socket did receive non-JSON response")
            }
        default:
            break
        }
    }
}
