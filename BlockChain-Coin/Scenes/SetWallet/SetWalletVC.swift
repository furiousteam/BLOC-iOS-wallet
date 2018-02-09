//
//  SetWalletVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 09/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol SetWalletDelegate: class {
    func didSetWallet(wallet: String)
}

class SetWalletVC: UIViewController {
    var wallet: String?
    
    weak var delegate: SetWalletDelegate?
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 14.0, weight: .bold)
        textField.placeholder = "Configure wallet address"
        textField.clearButtonMode = .always
        return textField
    }()
    
    init(wallet: String?, delegate: SetWalletDelegate?) {
        self.wallet = wallet
        self.delegate = delegate
        
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
    }
    
    @objc func didTapDone() {
        if let newWallet = textField.text, newWallet.isEmpty == false {
            delegate?.didSetWallet(wallet: newWallet)
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}
