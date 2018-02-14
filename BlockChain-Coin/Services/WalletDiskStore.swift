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
            print(error)
            return nil
        }
    }
    
    func generateKeyPair(seed: Seed) -> KeyPair? {
        return KeyPair(seed: seed)
    }
    
    func listWallets(completion: @escaping WalletStoreListWalletsCompletionHandler) {
        guard let data = KeychainWrapper.standard.data(forKey: "wallets"),
              let wallets = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Wallet] else {
                completion(.success(result: []))
                return
        }
        
        completion(.success(result: wallets.sorted(by: { (a, b) -> Bool in
            return a.createdAt > b.createdAt
        })))
    }
    
    func addWallet(keyPair: KeyPair, address: String?, completion: @escaping WalletStoreAddWalletCompletionHandler) {
        guard let address = address else {
            completion(.failure(error: .couldNotCreateWallet))
            return
        }
        
        var wallets: [Wallet] = (KeychainWrapper.standard.object(forKey: "wallets") as? [Wallet]) ?? []
        
        if wallets.contains(where: { $0.keyPair == keyPair }) == false {
            let newWallet = Wallet(keyPair: keyPair, address: address, createdAt: Date())
            wallets.append(newWallet)
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: wallets)
        KeychainWrapper.standard.set(data, forKey: "wallets")
        
        completion(.success(result: address))
    }
    
    // Ignored methods
    
    func connect(host: String, port: Int) {
        return
    }
    
    func disconnect() {
        return
    }
    
    func getBalance(address: String, completion: @escaping WalletStoreGetBalanceCompletionHandler) {
        completion(.success(result: []))
    }
    
}
