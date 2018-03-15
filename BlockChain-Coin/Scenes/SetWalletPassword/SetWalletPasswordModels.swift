//  
//  SetWalletPasswordModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct SetWalletPasswordForm {
    var password: String?
    var passwordBis: String?
    
    var isValid: Bool {
        let isPasswordValid: Bool = {
            guard let password = password, !password.isEmpty, let passwordBis = passwordBis, !passwordBis.isEmpty else { return false }
            
            // TODO: Check password requierements
            guard password.utf8.count >= 8 else { return false }
            
            guard password == passwordBis else { return false }
            
            return true
        }()
                
        return isPasswordValid
    }
}

struct SetWalletPasswordViewModel {
    enum State {
        case invalidForm
        case validForm
        case loading
        case error(String)
        case completed(WalletModel)
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

struct SetWalletPasswordRequest {
    let form: SetWalletPasswordForm
}

struct SetWalletPasswordResponse {
    let wallet: WalletModel
}
