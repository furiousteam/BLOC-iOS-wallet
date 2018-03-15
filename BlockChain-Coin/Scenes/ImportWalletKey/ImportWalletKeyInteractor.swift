//  
//  ImportWalletKeyInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol ImportWalletKeyBusinessLogic {
    var presenter: ImportWalletKeyPresentationLogic? { get set }

}

class ImportWalletKeyInteractor: ImportWalletKeyBusinessLogic {
    var presenter: ImportWalletKeyPresentationLogic?
    
    init() {

    }
}
