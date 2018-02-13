//
//  WalletDiskStore.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

class WalletDiskStore: WalletStore {
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
        // TODO
        completion(.success(result: []))
    }
    
    // Ignored methods
    
    func connect(host: String, port: Int) {
        return
    }
    
    func disconnect() {
        return
    }
    
    func addWallet(keyPair: KeyPair, completion: @escaping WalletStoreAddWalletCompletionHandler) {
        
    }

}
