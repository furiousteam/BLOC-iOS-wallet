//
//  WalletAPI.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire

enum WalletAPITarget: TargetType {
    case createWallet(publicKey: String, uuid: String, walletPrivateKey: String?)
    
    var baseURL: URL {
        return URL(string: "http://localhost:8080/api/v1")!
    }
    
    var path: String {
        switch self {
        case .createWallet:
            return "wallets"
        }
    }
    
    var task: Moya.Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        } else {
            return .requestPlain
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding()
        default:
            return JSONEncoding()
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .createWallet(let publicKey, let uuid, let walletPrivateKey):
            var parameters: [String: Any] = [ "userId": uuid,
                                              "userPublicKey": publicKey ]
            
            if let walletPrivateKey = walletPrivateKey { parameters["secretKey"] = walletPrivateKey }
            
            return parameters
        }
    }
    
    var multipartBody: [Moya.MultipartFormData]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
}

class WalletAPI: WalletStore {    
    private let provider = MoyaProvider<WalletAPITarget>()
    private let disposeBag = DisposeBag()
    
    func addWallet(keyPair: KeyPair, uuid: UUID, secretKey: String?, address: String?, completion: @escaping WalletStoreAddWalletCompletionHandler) {
        let endpoint = WalletAPITarget.createWallet(publicKey: keyPair.publicKey.bytes.toHexString(), uuid: uuid.uuidString, walletPrivateKey: secretKey)

        provider.rx.request(endpoint).handleErrorIfNeeded().map(WalletAPICreateResponse.self).subscribe(onSuccess: { response in
            completion(.success(result: response.address))
        }, onError: { error in
            // TODO: Better error handling
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }
    
    func listWallets(completion: @escaping WalletStoreListWalletsCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func getBalance(address: String, completion: @escaping WalletStoreGetBalanceCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func getTransactions(address: String, completion: @escaping WalletStoreGetTransactionsCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func generateSeed() -> Seed? {
        return nil
    }
    
    func generateKeyPair(seed: Seed) -> KeyPair? {
        return nil
    }
    
}
