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
    func fetchStats(settings: MiningSettingsModel)
    func login(wallet: String)
}

class MineInteractor: MineBusinessLogic, MinerStoreDelegate, PoolSocketDelegate {
    var presenter: MinePresentationLogic?
    
    let walletWorker: WalletWorker
    let walletAPIWorker: WalletWorker
    var poolWorker: PoolWorker!
    let minerWorker = MinerWorker(store: CryptonightMiner())
    let poolAPIWorker = PoolWorker(store: PoolAPI())

    var numberOfThreads: Int = 1
    
    var wallet: String = ""
    
    init() {
        switch AppController.environment {
        case .development, .production:
            walletWorker = WalletWorker(store: WalletDiskStore())
            walletAPIWorker = WalletWorker(store: WalletAPI())
        case .mock:
            walletWorker = WalletWorker(store: WalletMemStore())
            walletAPIWorker = WalletWorker(store: WalletMemStore())
        }
    }

    func connect(host: String, port: Int, wallet: String) {
        self.wallet = wallet
        
        self.poolWorker = PoolWorker(store: PoolSocketClient(delegate: self))
        
        let address = "\(host):\(port)"
        
        log.info("Connecting to \(address)")
        
        self.presenter?.handlePoolConnecting(address: address)
        
        poolWorker.connect(host: host, port: port) { _ in }
    }
    
    func disconnect() {
        minerWorker.stop { [weak self] result in
            self?.poolWorker.disconnect { _ in }
        }
    }
    
    func login(wallet: String) {
        poolWorker.login(username: wallet, password: UUID().uuidString) { _ in }
    }
    
    fileprivate func mine(job: JobModel, threads: Int) {
        minerWorker.mine(job: job, threadLimit: threads, delegate: self)
    }
    
    func fetchSettings() {
        minerWorker.fetchSettings { [weak self] result in
            switch result {
            case .success(let settings):
                self?.walletWorker.listWallets(completion: { [weak self] listResult in
                    switch listResult {
                    case .success(let wallets):
                        let sortedWallets = wallets.sorted(by: { a, b in return a.createdAt < b.createdAt })

                        guard sortedWallets.count > 0 else {
                            self?.presenter?.handleShowError(error: .couldNotFetchSettings)
                            return
                        }
                        
                        if sortedWallets.contains(where: { $0.address == settings.wallet.address }) == false {
                            guard let wallet = sortedWallets.first as? Wallet else {
                                self?.presenter?.handleShowError(error: .couldNotFetchSettings)
                                return
                            }
                            
                            let settings = MiningSettings(threads: settings.threads, wallet: wallet, pool: settings.pool)
                            
                            self?.minerWorker.saveSettings(settings: settings)
                        }
                        
                        self?.presenter?.handleShowSettings(settings: settings)
                    case .failure:
                        self?.presenter?.handleShowError(error: .couldNotFetchSettings)
                    }
                })
            case .failure:
                self?.walletWorker.listWallets { [weak self] result in
                    switch result {
                    case .success(let wallets):
                        let sortedWallets = wallets.sorted(by: { a, b in return a.createdAt < b.createdAt })

                        guard let wallet = sortedWallets.first as? Wallet, let pool = CryptonightMiner.defaultMiningPools.first else {
                            self?.presenter?.handleShowError(error: .couldNotFetchSettings)
                            return
                        }
                        
                        let numberOfThreads = UInt(floor(Double(ProcessInfo.processInfo.activeProcessorCount) / 2.0))
                        let settings = MiningSettings(threads: numberOfThreads, wallet: wallet, pool: pool)
                        
                        self?.minerWorker.saveSettings(settings: settings)
                        
                        self?.presenter?.handleShowSettings(settings: settings)
                    case .failure:
                        self?.presenter?.handleShowError(error: .couldNotFetchSettings)
                    }
                }
            }
        }
    }
    
    func fetchStats(settings: MiningSettingsModel) {
        poolAPIWorker.stats(pool: settings.pool) { [weak self] result in
            switch result {
            case .success(let pool):
                if let stats = pool.stats {
                    self?.presenter?.handleOtherPoolStats(stats: stats)
                }
            case .failure(let error):
                log.error(error)
                break
            }
        }
        
        poolAPIWorker.addressStats(pool: settings.pool, address: settings.wallet.address) { [weak self] result in
            switch result {
            case .success(let stats):
                self?.presenter?.handleAddressMiningStats(stats: stats)
            case .failure(let error):
                log.error(error)
                break
            }
        }
        
        minerWorker.fetchSettings { [weak self] result in
            switch result {
            case .success(let settings):
                self?.walletAPIWorker.getBalanceAndTransactions(wallet: settings.wallet, password: settings.wallet.password ?? "") { [weak self] result in
                    switch result {
                    case .success(let details):
                        guard settings.wallet.details?.availableBalance != details.availableBalance else { return }
                        
                        let wallet = settings.wallet
                        wallet.details = details
                        
                        let settings = MiningSettings(threads: settings.threads, wallet: wallet, pool: settings.pool)
                        
                        self?.minerWorker.saveSettings(settings: settings)

                        self?.presenter?.handleShowSettings(settings: settings)
                    case .failure(let error):
                        log.error(error)
                        break
                    }
                }
            case .failure(let error):
                log.error(error)
                break
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
    
    // MARK: - Socket delegate
    
    func didConnect(toHost host: String) {
        self.presenter?.handlePoolConnected(address: host)
        
        self.login(wallet: wallet)
    }
    
    func didDisconnect(error: Error?) {
        minerWorker.stop { [weak self] result in
            self?.presenter?.handlePoolDisconnected()
        }
    }
    
    func didReceiveJob(job: JobModel) {
        self.mine(job: job, threads: self.numberOfThreads)
    }
    
    func didSendJob() {
        log.info("Job submitted")
        self.presenter?.handleJobSubmitted()
    }
    
    func didFailWithError(error: PoolStoreError) {
        self.presenter?.handlePoolConnectionError(address: "", error: error)
    }

}
