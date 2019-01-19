//
//  APIError.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 23/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol APIErrorModel {
    var httpStatus: Int { get }
    var description: String { get }
    var code: Int { get }
}

struct APIError: APIErrorModel, Decodable {
    let httpStatus: Int
    let description: String
    let code: Int
}
