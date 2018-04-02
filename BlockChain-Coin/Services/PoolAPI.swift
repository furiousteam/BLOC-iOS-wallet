//
//  PoolAPI.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire
import SwiftKeychainWrapper

enum PoolAPITarget: TargetType {
    case stats(pool: MiningPoolModel)
    case walletStats(pool: MiningPoolModel, wallet: String)
    
    var baseURL: URL {
        switch self {
        case .stats(let pool):
            return URL(string: "\(pool.host):8111/") ?? URL(string: "http://blockchain-coin.co")!
        case .walletStats(let pool, _):
            return URL(string: "\(pool.host):8111/") ?? URL(string: "http://blockchain-coin.co")!
        }
    }
    
    var path: String {
        switch self {
        case .stats:
            return "stats"
        case .walletStats:
            return "stats_address"
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
        return .get
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
        case .stats:
            return nil
        case .walletStats(_, let wallet):
            return [ "address": wallet ]
        }
    }
    
    var multipartBody: [Moya.MultipartFormData]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
}

class PoolAPI: PoolStore {
    private let provider = MoyaProvider<PoolAPITarget>()
    private let disposeBag = DisposeBag()
    
    func stats(pool: MiningPoolModel, completion: @escaping PoolStoreStatsCompletionHandler) {
        let endpoint = PoolAPITarget.stats(pool: pool)
        
        provider.rx.request(endpoint).handleErrorIfNeeded().map(PoolStats.self).map({ stats -> MiningPoolModel in
            return MiningPool(host: pool.host, port: pool.port, stats: stats)
        }).subscribe(onSuccess: { response in
            completion(.success(result: response))
        }, onError: { error in
            // TODO: Better error handling
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }
    
    func addressStats(pool: MiningPoolModel, address: String, completion: @escaping PoolStoreAddressStatsCompletionHandler) {
        let endpoint = PoolAPITarget.walletStats(pool: pool, wallet: address)
        
        provider.rx.request(endpoint).handleErrorIfNeeded().map(MiningAddressStats.self).subscribe(onSuccess: { response in
            completion(.success(result: response))
        }, onError: { error in
            // TODO: Better error handling
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }
    
    func stats(pools: [MiningPoolModel], completion: @escaping PoolStoreStatsMultipleCompletionHandler) {
        let requests: [Observable<MiningPoolModel>] = pools.flatMap { pool -> Observable<MiningPoolModel>? in
            let endpoint = PoolAPITarget.stats(pool: pool)
            
            let request = provider.rx.request(endpoint).handleErrorIfNeeded().map(PoolStats.self).map({ stats -> MiningPoolModel in
                return MiningPool(host: pool.host, port: pool.port, stats: stats)
            })
            
            return request.asObservable().catchErrorJustReturn(pool)
        }
        
        Observable.merge(requests).toArray().subscribe(onNext: { stats in
            completion(.success(result: stats))
        }, onError: { error in
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }
    
    func listPools(completion: @escaping PoolStoreListCompletionHandler) {
        do {
            guard let data = KeychainWrapper.standard.data(forKey: "pools"), let poolsData = NSKeyedUnarchiver.unarchiveObject(with: data) as? Data else {
                completion(.success(result: []))
                return
            }
            
            let pools = try JSONDecoder().decode([MiningPool].self, from: poolsData)
            
            completion(.success(result: pools))
        } catch {
            completion(.success(result: []))
        }
    }
    
    func addPool(pool: MiningPool) {
        var pools: [MiningPool] = {
            guard let data = KeychainWrapper.standard.data(forKey: "pools"), let walletsData = NSKeyedUnarchiver.unarchiveObject(with: data) as? Data else {
                return []
            }
            
            do {
                return try JSONDecoder().decode([MiningPool].self, from: walletsData)
            } catch {
                return []
            }
        }()
        
        if pools.contains(where: { $0.host == pool.host && $0.port == pool.port }) == false {
            pools.append(pool)
        }
        
        do {
            let poolsData = try JSONEncoder().encode(pools)
            let data = NSKeyedArchiver.archivedData(withRootObject: poolsData)
            KeychainWrapper.standard.set(data, forKey: "pools")
        } catch {
            log.error("Could not save pool")
        }
    }

    // MARK: - Ignored methods
    
    func connect(host: String, port: Int, completion: @escaping PoolStoreConnectCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func disconnect(completion: @escaping PoolStoreDisconnectCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func login(username: String, password: String, completion: @escaping PoolStoreLoginCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func submit(id: String, jobId: String, result: Data, nonce: UInt32, completion: @escaping PoolStoreSubmitJobCompletionHandler) {
        completion(.failure(error: .unknown))
    }

}
