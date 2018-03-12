//
//  RestoreWalletVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 07/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class RestoreWalletVC: UIViewController {

    let remoteWalletWorker = WalletWorker(store: WalletAPI())
    let localWalletWorker = WalletWorker(store: WalletDiskStore())

    @IBOutlet weak var textView: UITextView!
    
    @IBAction func restoreTapped(_ sender: Any) {
        let characters = Array(textView.text.characters)
        var keysStrings: [String] = []
        
        stride(from: 0, to: characters.count, by: 64).forEach {
            keysStrings.append(String(characters[$0..<min($0+64, characters.count)]))
        }
        
        let spendPrivateKey = keysStrings[2]
        
        if let seed = localWalletWorker.generateSeed(), let keyPair = localWalletWorker.generateKeyPair(seed: seed) {
            let uuid = UUID()
            
            remoteWalletWorker.addWallet(keyPair: keyPair, uuid: uuid, secretKey: spendPrivateKey, address: nil, completion: { [weak self] result in
                switch result {
                case .success(let address):
                    self?.localWalletWorker.addWallet(keyPair: keyPair, uuid: uuid, secretKey: spendPrivateKey, address: address, completion: { localResult in
                        switch localResult {
                        case .success:
                            print("New wallet created: \(address)")
                        case .failure(let error):
                            print("fail: \(error)")
                        }
                    })
                case .failure(let error):
                    print("fail: \(error)")
                }
            })
        }
    }
}
