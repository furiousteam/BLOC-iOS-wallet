//
//  PoolSocketLoginRequest.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol PoolSocketLoginRequestModel {
    var username: String { get }
    var password: String { get }
}

class PoolSocketLoginRequest: PoolSocketRequest, PoolSocketLoginRequestModel {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case method = "method"
        case tag = "id"
        case params = "params"
    }
    
    enum LoginCodingKeys: String, CodingKey {
        case username = "login"
        case password = "password"
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("login", forKey: .method)
        try container.encode(1, forKey: .tag)
        
        var loginInfos = container.nestedContainer(keyedBy: LoginCodingKeys.self, forKey: .params)
        try loginInfos.encode(username, forKey: .username)
        try loginInfos.encode(password, forKey: .password)
    }
}
