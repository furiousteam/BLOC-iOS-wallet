//  
//  AppInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol AppBusinessLogic {
    var presenter: AppPresentationLogic? { get set }

}

class AppInteractor: AppBusinessLogic {
    var presenter: AppPresentationLogic?
}
