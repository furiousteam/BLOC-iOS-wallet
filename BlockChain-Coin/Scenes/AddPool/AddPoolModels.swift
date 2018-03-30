//  
//  AddPoolModels.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

struct AddPoolForm {
    var url: String?
    var port: UInt?
    
    var isValid: Bool {

        let isURLValid: Bool = {
            guard let url = url, url.isValidURL() else { return false }
            
            return true
        }()
        
        let isPortValid: Bool = {
            guard let port = port, port > 0 else { return false }
            
            return true
        }()
        
        return isURLValid && isPortValid
    }
    
    init(url: String?, port: UInt?) {
        if let url = url {
            if url.isValidURL() {
                self.url = url
            } else if url.isEmpty == false, url.contains(":") == false, "http://\(url)".isValidURL() {
                self.url = "http://\(url)"
            } else {
                self.url = url
            }
        } else {
            self.url = url
        }
        
        self.port = port
    }
}

struct AddPoolViewModel {
    enum State {
        case invalidForm
        case validForm
        case loading
        case error(String)
        case completed
    }
    
    let isNextButtonEnabled: Bool
    let state: State
    
    init(state: State) {
        var isNextButtonEnabled: Bool = true
        
        switch state {
        case .invalidForm:
            isNextButtonEnabled = false
        case .validForm:
            break
        case .loading:
            isNextButtonEnabled = false
        case .error:
            break
        case .completed:
            break
        }
        
        self.isNextButtonEnabled = isNextButtonEnabled
        self.state = state
    }
}

struct AddPoolRequest {
    let form: AddPoolForm
}
