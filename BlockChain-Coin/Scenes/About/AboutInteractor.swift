//  
//  AboutInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol AboutBusinessLogic {
    var presenter: AboutPresentationLogic? { get set }

}

class AboutInteractor: AboutBusinessLogic {
    var presenter: AboutPresentationLogic?
    
    init() {

    }
}
