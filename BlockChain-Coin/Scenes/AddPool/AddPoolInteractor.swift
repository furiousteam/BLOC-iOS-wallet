//  
//  AddPoolInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol AddPoolBusinessLogic {
    var presenter: AddPoolPresentationLogic? { get set }
    
    func validateForm(request: AddPoolRequest)
    func addPool(request: AddPoolRequest)

}

class AddPoolInteractor: AddPoolBusinessLogic {
    var presenter: AddPoolPresentationLogic?
    
    let poolWorker = PoolWorker(store: PoolAPI())
    
    func validateForm(request: AddPoolRequest) {
        presenter?.handleFormIsValid(valid: request.form.isValid)
    }
    
    func addPool(request: AddPoolRequest) {
        guard let url = request.form.url, let port = request.form.port, request.form.isValid == true else { return }
        
        let pool = MiningPool(host: url, port: Int(port), stats: nil)
        
        poolWorker.addPool(pool: pool)
        
        presenter?.handlePoolAdded()
    }
}
