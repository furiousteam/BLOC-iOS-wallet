//
//  PrimitiveSequence+ErrorHandling.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    public func handleErrorIfNeeded() -> Single<ElementType> {
        return flatMap { response -> Single<ElementType> in
            return Single.just(try response.handleErrorIfNeeded())
        }
    }
}
