//
//  MineVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class MineVC: UIViewController {

    /*let poolClient = PoolSocketClient(host: "159.89.180.132",
                                      port: 4444,
                                      walletAddress: "b12iFt4XPAu96TUCAXjdznDa3KUWQ1bq4djYZGARRp6b3KYj3RtQeykaXiKC6rqJYk4PiD6qCorWE2i9FCi1Gr8Z29E3Rqx1r",
                                      password: "password")*/
    
    let poolClient = PoolSocketClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        poolClient.connect(host: "miningpool.blockchain-coin.net", port: 4444) { connectResult in
            print("Connected: \(connectResult)")
            
            self.poolClient.login(username: "b12iFt4XPAu96TUCAXjdznDa3KUWQ1bq4djYZGARRp6b3KYj3RtQeykaXiKC6rqJYk4PiD6qCorWE2i9FCi1Gr8Z29E3Rqx1r", password: "x", completion: { job in
                print("Job: \(job)")
            })
        }
    }
}
