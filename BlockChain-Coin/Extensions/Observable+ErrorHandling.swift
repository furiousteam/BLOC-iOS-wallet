//
//  Observable+ErrorHandling.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension ObservableType where E == Moya.Response {
    public func handleErrorIfNeeded() -> Observable<E> {
        return flatMap { response -> Observable<E> in
            return Observable.just(try response.handleErrorIfNeeded())
        }
    }
}
