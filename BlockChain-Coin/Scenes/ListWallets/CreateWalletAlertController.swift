//
//  CreateWalletAlertController.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 16/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class CreateWalletAlertController: UIAlertController {
    
    var didTapNewWallet: () -> () = { }
    var didTapImportWalletWithKey: () -> () = { }
    var didTapImportWalletWithQRCode: () -> () = { }

    func setup(title: String?, message: String?) {
        self.title = title
        self.message = message
        
        addAction(UIAlertAction(title: R.string.localizable.create_wallet_alert_create(), style: .default) { _ in
            self.didTapNewWallet()
        })
        
        addAction(UIAlertAction(title: R.string.localizable.create_wallet_alert_import_key(), style: .default) { _ in
            self.didTapImportWalletWithKey()
        })
        
        addAction(UIAlertAction(title: R.string.localizable.create_wallet_alert_import_qr(), style: .default) { _ in
            self.didTapImportWalletWithQRCode()
        })
        
        addAction(UIAlertAction(title: R.string.localizable.common_cancel(), style: .cancel, handler: nil))
    }
    
}
