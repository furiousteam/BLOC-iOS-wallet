//
//  ShowWalletVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class ShowWalletVC: UIViewController {

    let walletWorker = WalletRPC()

    let wallet: WalletModel
    
    init(wallet: WalletModel) {
        self.wallet = wallet
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walletWorker.getBalance(address: wallet.address) { result in
            print(result)
        }
    }
    
}
