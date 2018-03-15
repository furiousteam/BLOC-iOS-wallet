//
//  WalletRPC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 10/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import JSONRPCKit
import APIKit

struct MyServiceRequest<Batch: JSONRPCKit.Batch>: APIKit.Request {
    let batch: Batch
    
    typealias Response = Batch.Responses
    
    var baseURL: URL {
        return URL(string: "http://138.68.237.176:8070")!
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/json_rpc"
    }
    
    var parameters: Any? {
        return batch.requestObject
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try batch.responses(from: object)
    }
}

class WalletRPC: WalletStore {
    func addWallet(keyPair: KeyPair, uuid: UUID, secretKey: String?, password: String?, address: String?, completion: @escaping WalletStoreAddWalletCompletionHandler) {
        let batchFactory = BatchFactory(version: "2.0", idGenerator: NumberIdGenerator())
        let request = WalletRPCAddWalletRequest(publicKey: keyPair.publicKey)
        let batch = batchFactory.create(request)
        let httpRequest = MyServiceRequest(batch: batch)
        
        Session.send(httpRequest) { result in
            switch result {
            case .success(let address):
                completion(.success(result: address))
            case .failure:
                completion(.failure(error: .couldNotCreateWallet))
            }
        }
    }
    
    func getBalanceAndTransactions(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetBalanceAndTransactionsCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func getKeys(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetKeysCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    // MARK: - Ignored methods
    
    func generateSeed() -> Seed? {
        return nil
    }
    
    func generateKeyPair(seed: Seed) -> KeyPair? {
        return nil
    }
    
    func listWallets(completion: @escaping WalletStoreListWalletsCompletionHandler) {
        completion(.success(result: []))
    }
    
}
