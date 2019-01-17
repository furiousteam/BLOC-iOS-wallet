//  
//  NewTransactionModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 21/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct NewTransactionWalletsViewModel {
    enum State {
        case loading
        case loaded([WalletModel])
        case error(String)
    }
    
    let state: State
    let wallets: [WalletModel]
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .loaded(let wallets):
            self.wallets = wallets
        default:
            self.wallets = []
        }
    }
}

struct NewTransactionForm {
    var amount: Double?
    var address: String?
    var sourceWallet: WalletModel?
    var paymentId: String?
    
    var isValid: Bool {
        let isAmountValid: Bool = {
            guard let amount = amount else { return false }
            
            guard amount > (Constants.minimumFee / Constants.walletCurrencyDivider) else { return false }
            
            return true
        }()
        
        let isAddressValid: Bool = {
            guard let address = address, !address.isEmpty else { return false }
            
            do {
                let address = try Address(addressString: address)
                
                return try address.validate()
            } catch {
                return false
            }
        }()
        
        let isSourceAddressValid: Bool = {
            guard let sourceWallet = sourceWallet, !sourceWallet.address.isEmpty else { return false }
            
            do {
                let address = try Address(addressString: sourceWallet.address)
                
                return try address.validate()
            } catch {
                return false
            }
        }()
        
        let isPaymentIdValid: Bool = {
            guard let paymentId = paymentId?.uppercased() else { return true }
            
            guard paymentId.count == 64 else { return false }
            
            let characterSet = CharacterSet(charactersIn: "0123456789ABCDEF").inverted
            
            return (paymentId as NSString).rangeOfCharacter(from: characterSet).location == NSNotFound
        }()
        
        return isAmountValid && isAddressValid && isSourceAddressValid && isPaymentIdValid
    }
}

struct NewTransactionViewModel {
    enum State {
        case invalidForm
        case validForm
        case loading
        case error(String)
        case completed(Transaction)
    }
    
    let isNextButtonEnabled: Bool
    let showLoadingIndicator: Bool
    let hasError: Bool
    let errorMessage: String?
    let state: State
    
    init(state: State) {
        var isNextButtonEnabled: Bool = true
        var showLoadingIndicator: Bool = false
        var hasError: Bool = false
        var errorMessage: String? = nil
        
        switch state {
        case .invalidForm:
            isNextButtonEnabled = false
        case .validForm:
            break
        case .loading:
            isNextButtonEnabled = false
            showLoadingIndicator = true
        case .error(let error):
            hasError = true
            errorMessage = error
        case .completed:
            break
        }
        
        self.isNextButtonEnabled = isNextButtonEnabled
        self.showLoadingIndicator = showLoadingIndicator
        self.hasError = hasError
        self.errorMessage = errorMessage
        self.state = state
    }
}

struct NewTransactionRequest {
    let form: NewTransactionForm
}
