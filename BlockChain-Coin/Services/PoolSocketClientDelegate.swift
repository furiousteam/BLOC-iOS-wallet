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
    var didWrite: () -> Void = { }
    
    var connectionCallback: PoolStoreConnectCompletionHandler?
    var disconnectionCallback: PoolStoreDisconnectCompletionHandler?
    var loginCallback: PoolStoreLoginCompletionHandler?
    var submitJobCallback: PoolStoreSubmitJobCompletionHandler?

    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.connectionCallback?(.success(result: true))
            self.connectionCallback = nil
        }

    }
        
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        log.error(err)
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.disconnectionCallback?(.success(result: true))
            self.disconnectionCallback = nil
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
                loginCallback?(.success(result: jobResponse.job))
                loginCallback = nil
            } else if let jobResponse = try? JSONDecoder().decode(PoolSocketJobNotificationResponse.self, from: data) {
                submitJobCallback?(.success(result: jobResponse.job))
                submitJobCallback = nil
            } else if let _ = try? JSONDecoder().decode(PoolSocketOKResponse.self, from: data) {
                log.info("Job submitted")
            } else if let error = try? JSONDecoder().decode(PoolSocketErrorResponse.self, from: data) {
                log.error("Error: \(error.code) - \(error.message)")
                
                if error.code == -1 && error.message == "Invalid job id" {
                    NotificationCenter.default.post(name: .loginMining, object: nil)
                } else if error.code == -1 && error.message == "Unauthenticated" {
                    NotificationCenter.default.post(name: .loginMining, object: nil)
                }
            } else {
                let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any]
                log.error("Could not read result data")
                log.error(String(describing: json))
                
                if let loginCallback = loginCallback {
                    loginCallback(.failure(error: .cantReadData))
                    self.loginCallback = nil
                } else if let submitJobCallback = submitJobCallback {
                    submitJobCallback(.failure(error: .cantReadData))
                    self.submitJobCallback = nil
                }
            }
        default:
            break
        }
    }
}
