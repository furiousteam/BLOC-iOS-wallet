//  
//  ImportWalletKeyModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct ImportWalletKeyForm {
    var keysString: String?
    var password: String
    
    var spendPrivateKey: String? {
        guard let keysString = keysString else { return nil }
        
        let characters = Array(keysString.characters)
        var ks: [String] = []
        
        stride(from: 0, to: characters.count, by: 64).forEach {
            ks.append(String(characters[$0..<min($0+64, characters.count)]))
        }
        
        guard ks.count == 4 else { return nil }
        
        return ks[2]
    }
    
    var isValid: Bool {
        let isValidLength: Bool = {
            guard let keysString = keysString else { return false }
            
            return keysString.utf8.count == 256
        }()
        
        let isValidKey: Bool = {
            guard let _ = spendPrivateKey else { return false }
            
            return true
        }()
        
        return isValidLength && isValidKey
    }
}

struct ImportWalletKeyViewModel {
    enum State {
        case invalidForm
        case validForm
        case loading
        case error(String)
        case completed(WalletModel)
    }
    
    let showLoadingIndicator: Bool
    let hasError: Bool
    let errorMessage: String?
    let state: State
    
    init(state: State) {
        var showLoadingIndicator: Bool = false
        var hasError: Bool = false
        var errorMessage: String? = nil
        
        switch state {
        case .invalidForm:
            break
        case .validForm:
            break
        case .loading:
            showLoadingIndicator = true
        case .error(let error):
            hasError = true
            errorMessage = error
        case .completed:
            break
        }
        
        self.showLoadingIndicator = showLoadingIndicator
        self.hasError = hasError
        self.errorMessage = errorMessage
        self.state = state
    }
}

struct ImportWalletKeyRequest {
    let form: ImportWalletKeyForm
}

struct ImportWalletKeyResponse {
    let wallet: WalletModel
}

