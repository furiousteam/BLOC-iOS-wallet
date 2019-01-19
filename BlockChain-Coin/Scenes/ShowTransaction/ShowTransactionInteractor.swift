//  
//  ShowTransactionInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 25/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol ShowTransactionBusinessLogic {
    var presenter: ShowTransactionPresentationLogic? { get set }

}

class ShowTransactionInteractor: ShowTransactionBusinessLogic {
    var presenter: ShowTransactionPresentationLogic?
    
    init() {

    }
}
