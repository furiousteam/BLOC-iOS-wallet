//
//  WalletDiskStore.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class WalletDiskStore: WalletStore {
    private let cache = UserDefaults.standard

    func generateSeed() -> Seed? {
        do {
            return try Seed()
        } catch {
            log.error(error)
            return nil
        }
    }
    
    func generateKeyPair(seed: Seed) -> KeyPair? {
        return KeyPair(seed: seed)
    }
    
    func listWallets(completion: @escaping WalletStoreListWalletsCompletionHandler) {
        do {
            guard let data = KeychainWrapper.standard.data(forKey: "wallets"), let walletsData = NSKeyedUnarchiver.unarchiveObject(with: data) as? Data else {
                    completion(.success(result: []))
                    return
            }
            
            let wallets = try JSONDecoder().decode([Wallet].self, from: walletsData)
            
            completion(.success(result: wallets.sorted(by: { (a, b) -> Bool in
                return a.createdAt > b.createdAt
            })))
        } catch {
            completion(.success(result: []))
        }
        
    }
    
    func addWallet(keyPair: KeyPair, uuid: UUID, secretKey: String?, password: String?, address: String?, name: String, details: WalletDetails?, completion: @escaping WalletStoreAddWalletCompletionHandler) {
        guard let address = address, let password = password else {
            completion(.failure(error: .couldNotCreateWallet))
            return
        }
        
        var wallets: [Wallet] = {
            guard let data = KeychainWrapper.standard.data(forKey: "wallets"), let walletsData = NSKeyedUnarchiver.unarchiveObject(with: data) as? Data else {
                return []
            }
            
            do {
                return try JSONDecoder().decode([Wallet].self, from: walletsData)
            } catch {
                return []
            }
        }()
        
        if wallets.contains(where: { $0.uuid == uuid }) == false {
            let newWallet = Wallet(uuid: uuid, keyPair: keyPair, address: address, password: password, name: name, details: details, createdAt: Date())
            wallets.append(newWallet)
        }
        
        do {
            let walletsData = try JSONEncoder().encode(wallets)
            let data = NSKeyedArchiver.archivedData(withRootObject: walletsData)
            KeychainWrapper.standard.set(data, forKey: "wallets")
            
            completion(.success(result: address))
        } catch {
            completion(.failure(error: .couldNotCreateWallet))
        }
    }
    
    func remove(wallet: WalletModel) {
        var wallets: [Wallet] = {
            guard let data = KeychainWrapper.standard.data(forKey: "wallets"), let walletsData = NSKeyedUnarchiver.unarchiveObject(with: data) as? Data else {
                return []
            }
            
            do {
                return try JSONDecoder().decode([Wallet].self, from: walletsData)
            } catch {
                return []
            }
        }()

        if let index = wallets.index(where: { $0.address == wallet.address }) {
            wallets.remove(at: index)
        }
        
        do {
            let walletsData = try JSONEncoder().encode(wallets)
            let data = NSKeyedArchiver.archivedData(withRootObject: walletsData)
            KeychainWrapper.standard.set(data, forKey: "wallets")
        } catch {
            log.error("Could not remove wallet")
        }
    }
    
    // Ignored methods
    
    func connect(host: String, port: Int) {
        return
    }
    
    func disconnect() {
        return
    }
    
    func getBalanceAndTransactions(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetBalanceAndTransactionsCompletionHandler) {
        var wallets: [Wallet] = {
            guard let data = KeychainWrapper.standard.data(forKey: "wallets"), let walletsData = NSKeyedUnarchiver.unarchiveObject(with: data) as? Data else {
                return []
            }
            
            do {
                return try JSONDecoder().decode([Wallet].self, from: walletsData)
            } catch {
                return []
            }
        }()

        guard let walletIndex = wallets.index(where: { $0.uuid == wallet.uuid }), let updatedWallet = (wallet as? Wallet), let details = updatedWallet.details else {
            completion(.failure(error: .unknown))
            return
        }
        
        wallets[walletIndex] = updatedWallet
        
        do {
            let walletsData = try JSONEncoder().encode(wallets)
            let data = NSKeyedArchiver.archivedData(withRootObject: walletsData)
            KeychainWrapper.standard.set(data, forKey: "wallets")
            
            completion(.success(result: details))
        } catch {
            completion(.failure(error: .unknown))
        }
    }
    
    func getAllWalletDetails(wallets: [WalletModel], completion: @escaping WalletStoreGetAllWalletDetailsCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func getKeys(wallet: WalletModel, password: String, completion: @escaping WalletStoreGetKeysCompletionHandler) {
        completion(.failure(error: .unknown))
    }
    
    func transfer(wallet: WalletModel, password: String, destination: String, amount: Int64, fee: UInt64, anonymity: UInt64, unlockHeight: UInt64?, paymentId: String?, completion: @escaping WalletStoreTransferCompletionHandler) {
        completion(.failure(error: .unknown))
    }

}
