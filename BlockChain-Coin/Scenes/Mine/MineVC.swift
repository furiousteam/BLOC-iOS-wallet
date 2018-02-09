//
//  MineVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import SnapKit

class MineVC: UIViewController, MinerStoreDelegate {
    let poolClient = PoolSocketClient()
    let miner = CryptonightMiner()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        poolClient.connect(host: "miningpool.blockchain-coin.net", port: 4444) { connectResult in
            print("Connected: \(connectResult)")
            
            self.poolClient.login(username: "b12iFt4XPAu96TUCAXjdznDa3KUWQ1bq4djYZGARRp6b3KYj3RtQeykaXiKC6rqJYk4PiD6qCorWE2i9FCi1Gr8Z29E3Rqx1r", password: "x", completion: { loginResult in
                switch loginResult {
                case .success(let job):
                    self.miner.mine(job: job, threadLimit: ProcessInfo.processInfo.activeProcessorCount, delegate: self)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func didHash() {
    }
    
    func didUpdate(stats: StatsModel) {
    }
    
    func didComplete(id: String, jobId: String, result: Data, nonce: UInt32) {
        DispatchQueue.main.async {
            print("hash rate: \(self.miner.stats.hashRate)")
            print("hash rate: \(self.miner.stats.submittedHashes)")

            print("Has job to send: \(id) \(jobId) \(nonce)")
            
            self.poolClient.submit(id: id, jobId: jobId, result: result, nonce: nonce, completion: { result in
                print("Completed job sending \(result)")
                
                switch result {
                case .success(let job):
                    self.miner.job = job
                case .failure:
                    self.miner.job = nil
                }
            })
        }

    }

}
