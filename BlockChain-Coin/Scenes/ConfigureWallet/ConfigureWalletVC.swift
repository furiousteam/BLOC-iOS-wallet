//
//  ConfigureWalletVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 09/02/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ConfigureWalletDelegate: class {
    func didSetWallet(wallet: String)
}

class ConfigureWalletVC: UIViewController {
    var walletWorker: WalletWorker
    var localWalletWorker: WalletWorker

    var wallet: String?
    
    weak var delegate: ConfigureWalletDelegate?
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 14.0, weight: .bold)
        textField.placeholder = "Configure wallet address"
        textField.clearButtonMode = .always
        return textField
    }()
    
    init(wallet: String?, delegate: ConfigureWalletDelegate?) {
        self.wallet = wallet
        self.delegate = delegate
        
        self.walletWorker = WalletWorker(store: WalletAPI())
        self.localWalletWorker = WalletWorker(store:WalletDiskStore())

        super.init(nibName: nil, bundle: nil)
        
        self.title = "Configure Wallet"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = self.wallet
    
        view.backgroundColor = .white
        
        let okButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        self.navigationItem.setRightBarButton(okButton, animated: false)
        
        view.addSubview(textField)
        
        textField.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(25.0)
            $0.top.equalToSuperview().offset(100.0)
        })
        
        makeWallet()
    }
    
    @objc func didTapDone() {
        if let newWallet = textField.text, newWallet.isEmpty == false {
            delegate?.didSetWallet(wallet: newWallet)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Temp
    
    func makeWallet() {
        //walletWorker.connect(host: "usa2.blockchain-coin.net", port: 2086)
        
        if let seed = localWalletWorker.generateSeed() {
            let keypair = localWalletWorker.generateKeyPair(seed: seed)
            log.info(keypair)
        }
        
        /*inline void generate_keys(PublicKey &pub, SecretKey &sec) {
            crypto_ops::generate_keys(pub, sec);
        }*/
    }

    func walletStoreDidConnect() {
        log.info("did connect")
    }
    
    func walletStoreDidFailToConnect(error: WalletStoreError) {
        log.info("did fail to connect")
    }
    
    func walletStoreDidDisconnect() {
        log.info("did disconnect")
    }
    
    func walletStoreDidFailToDisconnectDisconnect(error: WalletStoreError) {
        log.info("did fail to disconnect")
    }
    
    func walletStore(didReceiveUnknownResponse: [String : Any]) {
        log.info("did receive unknown response")
    }

}
