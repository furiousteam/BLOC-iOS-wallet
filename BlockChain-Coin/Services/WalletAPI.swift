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
import CryptoSwift
import Base64

enum WalletAPITarget: TargetType {
    case createWallet(publicKey: String, uuid: String, walletPrivateKey: String?)
    case balanceAndTransactions(address: String, signature: String)
    case keys(address: String, signature: String)
    case transfer(sourceAddress: String, destinationAddress: String, amount: Int64, fee: UInt64, anonymity: UInt64, unlockHeight: UInt64?, paymentId: String?, signature: String)
    
    var baseURL: URL {
        return URL(string: "http://95.216.19.34/api/v1")!
    }
    
    var path: String {
        switch self {
        case .createWallet:
            return "wallets"
        case .balanceAndTransactions(let address, _):
            return "wallets/\(address)"
        case .keys(let address, _):
            return "keys/\(address)"
        case .transfer:
            return "transfer"
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
        switch self {
        case .createWallet, .transfer:
            return .post
        case .balanceAndTransactions, .keys:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .balanceAndTransactions(_, let signature), .keys(_, let signature), .transfer(_, _, _, _, _, _, _, let signature):
            return [ "X-BLOC-Auth": signature ]
        default:
            return nil
        }
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
        case .transfer(let sourceAddress, let destinationAddress, let amount, let fee, let anonymity, let unlockHeight, let paymentId, _):
            var parameters: [String: Any] = [ "sourceAddress": sourceAddress,
                                              "destinationAddress": destinationAddress,
                                              "amount": amount,
                                              "fee": fee,
                                              "anonymity": anonymity ]
            
            if let unlockHeight = unlockHeight { parameters["unlockHeight"] = unlockHeight }

            if let paymentId = paymentId { parameters["paymentId"] = paymentId }

            return parameters
        default:
            return nil
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
    
    func addWallet(keyPair: KeyPair, uuid: UUID, secretKey: String?, password: String?, address: String?, name: String, details: WalletDetails?, completion: @escaping WalletStoreAddWalletCompletionHandler) {
        let endpoint = WalletAPITarget.createWallet(publicKey: keyPair.publicKey.bytes.toHexString(), uuid: uuid.uuidString, walletPrivateKey: secretKey)

        provider.rx.request(endpoint).handleErrorIfNeeded().map(WalletAPICreateResponse.self).subscribe(onSuccess: { response in
            completion(.success(result: response.address))
        }, onError: { error in
            // TODO: Better error handling
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }
    
    func getBalanceAndTransactions(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetBalanceAndTransactionsCompletionHandler) {
        guard let signature = generateSignature(uuid: wallet.uuid.uuidString, keyPair: wallet.keyPair, password: password) else {
            completion(.failure(error: .couldNotConnect))
            return
        }
        
        let endpoint = WalletAPITarget.balanceAndTransactions(address: wallet.address, signature: signature)
        
        provider.rx.request(endpoint).handleErrorIfNeeded().map(WalletDetails.self).subscribe(onSuccess: { response in
            completion(.success(result: response))
        }, onError: { error in
            // TODO: Better error handling
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }
    
    func getAllWalletDetails(wallets: [WalletModel], completion: @escaping WalletStoreGetAllWalletDetailsCompletionHandler) {
        let requests: [Observable<WalletModel>] = wallets.flatMap { wallet -> Observable<WalletModel>? in
            guard let password = wallet.password, let signature = generateSignature(uuid: wallet.uuid.uuidString, keyPair: wallet.keyPair, password: wallet.password ?? "") else {
                completion(.failure(error: .couldNotConnect))
                return nil
            }

            let endpoint = WalletAPITarget.balanceAndTransactions(address: wallet.address, signature: signature)

            let request = provider.rx.request(endpoint).handleErrorIfNeeded().map(WalletDetails.self).map({ details -> WalletModel in
                return Wallet(uuid: wallet.uuid, keyPair: wallet.keyPair, address: wallet.address, password: password, name: wallet.name, details: details, createdAt: wallet.createdAt)
            })
            
            return request.asObservable().catchErrorJustReturn(wallet)
        }
        
        Observable.merge(requests).toArray().subscribe(onNext: { wallets in
            completion(.success(result: wallets))
        }, onError: { error in
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }
    
    func getKeys(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetKeysCompletionHandler) {
        guard let signature = generateSignature(uuid: wallet.uuid.uuidString, keyPair: wallet.keyPair, password: password) else {
            completion(.failure(error: .couldNotConnect))
            return
        }

        let endpoint = WalletAPITarget.keys(address: wallet.address, signature: signature)
        
        provider.rx.request(endpoint).handleErrorIfNeeded().map(WalletKeys.self).subscribe(onSuccess: { response in
            completion(.success(result: response))
        }, onError: { error in
            // TODO: Better error handling
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }
    
    func transfer(wallet: WalletModel, password: String, destination: String, amount: Int64, fee: UInt64, anonymity: UInt64, unlockHeight: UInt64?, paymentId: String?, completion: @escaping WalletStoreTransferCompletionHandler) {
        guard let signature = generateSignature(uuid: wallet.uuid.uuidString, keyPair: wallet.keyPair, password: password) else {
            completion(.failure(error: .couldNotConnect))
            return
        }
        
        let endpoint = WalletAPITarget.transfer(sourceAddress: wallet.address, destinationAddress: destination, amount: amount, fee: fee, anonymity: anonymity, unlockHeight: unlockHeight, paymentId: paymentId, signature: signature)
        
        provider.rx.request(endpoint).handleErrorIfNeeded().map(WalletAPITransferResponse.self).subscribe(onSuccess: { response in
            completion(.success(result: response.transactionHash))
        }, onError: { error in
            if let apiError = error as? NSError, let message = apiError.userInfo["message"] as? String {
                completion(.failure(error: .raw(string: "\(message) (code: \(apiError.code))")))
                return
            }
            
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }

    // Ignored methods
    
    func listWallets(completion: @escaping WalletStoreListWalletsCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func generateSeed() -> Seed? {
        return nil
    }
    
    func generateKeyPair(seed: Seed) -> KeyPair? {
        return nil
    }
    
    func remove(wallet: WalletModel) {
        return
    }
    
    // Signature
    
    func generateSignature(uuid: String, keyPair: KeyPair, password: String) -> String? {
        do {
            let passwordBytes: Array<UInt8> = Array(password.utf8)
            let saltBytes: Array<UInt8> = Array(uuid.utf8)
            
            let hash = try HKDF(password: passwordBytes, salt: saltBytes, variant: .sha256).calculate()
            
            let encHash = keyPair.sign(hash)
            
            let hashString = hash.toHexString()
            let encHashString = encHash.toHexString()
            
            let signature = [ uuid, hashString, encHashString ].joined(separator: ":").base64()
            
            return signature
        } catch {
            return nil
        }
    }
}
