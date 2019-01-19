//  
//  ConfirmTransactionInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import Foundation

protocol ConfirmTransactionBusinessLogic {
    var presenter: ConfirmTransactionPresentationLogic? { get set }

    func transfer(request: ConfirmTransactionRequest)
}

class ConfirmTransactionInteractor: ConfirmTransactionBusinessLogic {
    var presenter: ConfirmTransactionPresentationLogic?
    
    let walletWorker = WalletWorker(store: WalletAPI())
    
    func transfer(request: ConfirmTransactionRequest) {
        presenter?.handleShowLoading()
                
        walletWorker.transfer(wallet: request.form.sourceWallet!,
                              password: request.form.sourceWallet!.password!,
                              destination: request.form.address!,
                              amount: Int64(request.form.amount! * Constants.walletCurrencyDivider),
                              fee: UInt64(Constants.minimumFee),
                              anonymity: 0,
                              unlockHeight: nil,
                              paymentId: request.form.paymentId) { [weak self] result in
                                switch result {
                                case .success(let transactionHash):
                                    self?.presenter?.handleShowTransactionHash(transactionHash: transactionHash)
                                case .failure(let error):
                                    self?.presenter?.handleShowError(error: error)
                                }
        }
    }
}
