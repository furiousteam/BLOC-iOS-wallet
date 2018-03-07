//
//  RestoreWalletVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class RestoreWalletVC: UIViewController {

    let walletWorker = WalletWorker(store: WalletAPI())
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func restoreTapped(_ sender: Any) {
        walletWorker
    }
}
