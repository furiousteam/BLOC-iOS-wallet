//
//  MineInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol MineBusinessLogic {
    var presenter: MinePresentationLogic? { get set }
    
    func connect(host: String, port: Int, wallet: String)
    func disconnect()
    func fetchSettings()
}

class MineInteractor: MineBusinessLogic, MinerStoreDelegate {
    var presenter: MinePresentationLogic?
    
    let walletWorker = WalletWorker(store: WalletDiskStore())
    let poolWorker = PoolWorker(store: PoolSocketClient())
    let minerWorker = MinerWorker(store: CryptonightMiner())

    func connect(host: String, port: Int, wallet: String) {
        let address = "\(host):\(port)"
        
        log.info("Connecting to \(address)")
        
        self.presenter?.handlePoolConnecting(address: address)
        
        poolWorker.connect(host: host, port: port) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.handlePoolConnected(address: address)
                
                self?.login(wallet: wallet)
            case .failure(let error):
                self?.presenter?.handlePoolConnectionError(address: address, error: error)
            }
        }
    }
    
    func disconnect() {
        minerWorker.stop { [weak self] result in
            self?.poolWorker.disconnect { [weak self] _ in
                self?.presenter?.handlePoolDisconnected()
            }
        }
    }
    
    fileprivate func login(wallet: String) {
        poolWorker.login(username: wallet, password: "x") { [weak self] result in
            switch result {
            case .success(let job):
                self?.mine(job: job)
            case .failure:
                self?.presenter?.handlePoolConnectionError(address: nil, error: .couldNotConnect)
            }
        }
        
    }
    
    fileprivate func mine(job: JobModel) {
        minerWorker.mine(job: job, threadLimit: ProcessInfo.processInfo.activeProcessorCount, delegate: self)
    }
    
    func fetchSettings() {
        minerWorker.fetchSettings { [weak self] result in
            switch result {
            case .success(let settings):
                self?.presenter?.handleShowSettings(settings: settings)
            case .failure:
                self?.walletWorker.listWallets { [weak self] result in
                    switch result {
                    case .success(let wallets):
                        let sortedWallets = wallets.sorted(by: { a, b in return a.createdAt < b.createdAt })

                        guard let wallet = sortedWallets.first as? Wallet, let pool = CryptonightMiner.defaultMiningPools.first as? MiningPool else {
                            self?.presenter?.handleShowError(error: .couldNotFetchSettings)
                            return
                        }
                        
                        let settings = MiningSettings(power: .medium, wallet: wallet, pool: pool)
                        
                        self?.minerWorker.saveSettings(settings: settings)
                        
                        self?.presenter?.handleShowSettings(settings: settings)
                    case .failure:
                        self?.presenter?.handleShowError(error: .couldNotFetchSettings)
                    }
                }
            }
        }
    }
    
    // MARK: - Miner delegate
    
    func didHash() {
    }
    
    func didUpdate(stats: StatsModel) {
        presenter?.handlePoolStats(stats: stats)
    }
    
    func didComplete(id: String, jobId: String, result: Data, nonce: UInt32) {
        poolWorker.submit(id: id, jobId: jobId, result: result, nonce: nonce) { [weak self] result in
            switch result {
            case .success(let job):
                self?.minerWorker.updateJob(job: job)
            case .failure:
                self?.disconnect()
            }
        }        
    }
}
