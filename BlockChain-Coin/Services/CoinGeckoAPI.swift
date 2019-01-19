//
//  CoinGeckoAPI.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/12/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire

enum CoinGeckoAPITarget: TargetType {
    case priceHistory(days: String, currency: String)
    
    var baseURL: URL {
        return URL(string: "https://api.coingecko.com/api/v3/coins/bloc-money")!
    }
    
    var path: String {
        switch self {
        case .priceHistory:
            return "market_chart"
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
        case .priceHistory:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding()
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .priceHistory(let days, let currency):
            return [ "days": days,
                     "vs_currency": currency ]
        }
    }
    
    var multipartBody: [Moya.MultipartFormData]? {
        return nil
    }
    
    var sampleData: Data {
        return Data()
    }
}

class CoinGeckoAPI: PriceStore {
    private let provider = MoyaProvider<CoinGeckoAPITarget>()
    private let disposeBag = DisposeBag()
    
    func fetchPriceHistory(days: UInt?, currency: String, completion: @escaping PriceStoreGetPriceHistoryCompletionHandler) {
        let daysString: String = { if let days = days { return "\(days)" } else { return "30" } }()
        
        let endpoint = CoinGeckoAPITarget.priceHistory(days: daysString, currency: currency)
        
        provider.rx.request(endpoint).handleErrorIfNeeded().map(CoinGeckoPriceHistoryResponse.self).subscribe(onSuccess: { response in
            completion(.success(result: response.prices))
        }, onError: { error in
            completion(.failure(error: .unknown))
        }).disposed(by: disposeBag)
    }
}
