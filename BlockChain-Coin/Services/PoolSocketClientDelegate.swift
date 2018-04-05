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
    var prepareReceive: () -> Void = { }

    weak var delegate: PoolSocketDelegate?
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        log.info("Connected to host \(host)")
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.delegate?.didConnect(toHost: "\(host):\(port)")
        }
    }
        
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        log.error(err)
        
        log.info("Disconnected from host")

        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            
            self.delegate?.didDisconnect(error: err)
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        switch tag {
        case PoolSocketClient.Tags.write.rawValue:
            prepareReceive()
        default:
            break
        }
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any]

        log.info("Response: \(json)")
        
        switch tag {
        case PoolSocketClient.Tags.read.rawValue:
            if let jobResponse = try? JSONDecoder().decode(PoolSocketJobResponse.self, from: data) {
                self.delegate?.didReceiveJob(job: jobResponse.job)
            } else if let jobResponse = try? JSONDecoder().decode(PoolSocketJobNotificationResponse.self, from: data) {
                self.delegate?.didReceiveJob(job: jobResponse.job)
            } else if let _ = try? JSONDecoder().decode(PoolSocketOKResponse.self, from: data) {
                self.delegate?.didSendJob()
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
                
                self.delegate?.didFailWithError(error: .cantReadData)
            }
        default:
            break
        }
        
        prepareReceive()
    }
}
