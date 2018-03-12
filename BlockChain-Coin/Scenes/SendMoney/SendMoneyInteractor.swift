//  
//  SendMoneyInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol SendMoneyBusinessLogic {
    var presenter: SendMoneyPresentationLogic? { get set }

}

class SendMoneyInteractor: SendMoneyBusinessLogic {
    var presenter: SendMoneyPresentationLogic?
    
    init() {

    }
}
