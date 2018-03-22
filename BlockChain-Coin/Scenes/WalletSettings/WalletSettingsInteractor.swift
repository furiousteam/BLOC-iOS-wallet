//  
//  WalletSettingsInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol WalletSettingsBusinessLogic {
    var presenter: WalletSettingsPresentationLogic? { get set }

}

class WalletSettingsInteractor: WalletSettingsBusinessLogic {
    var presenter: WalletSettingsPresentationLogic?
    
    init() {

    }
}
