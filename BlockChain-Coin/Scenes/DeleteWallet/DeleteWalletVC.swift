//  
//  DeleteWalletVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 04/04/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class DeleteWalletVC: ViewController, CheckPasswordVCDelegate {
    
    let formView = ScrollableStackView()
    let formFields = DeleteWalletViews()

    let walletWorker = WalletWorker(store: WalletDiskStore())
    
    let router: DeleteWalletRoutingLogic
    
    let wallet: WalletModel
    
    // MARK: - View lifecycle
    
    init(wallet: WalletModel) {
        let router = DeleteWalletRouter()
        
        self.wallet = wallet
        
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
        
        router.viewController = self
    }
    
    init(router: DeleteWalletRoutingLogic, wallet: WalletModel) {
        self.router = router
        
        self.wallet = wallet
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }

    // MARK: - Configuration
    
    override func configure() {
        super.configure()
        
        view.backgroundColor = .clear
        
        view.addSubview(formView)
        
        formView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // Form
        
        formView.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        formFields.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_wallet_title(), subtitle: wallet.name)
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    // MARK: - Actions
    
    @objc func deleteTapped() {
        guard let titleView = self.navigationItem.titleView as? TitleView else { return }
        
        let vc = CheckPasswordVC(wallet: wallet, titleView: titleView, delegate: self)
        present(NavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc func backTapped() {
        router.goBack()
    }
    
    // MARK: - Check password delegate
    
    func didEnterPassword(checkPasswordVC: CheckPasswordVC, string: String) {
        guard let wp = wallet.password, string == wp else {
            return
        }
        
        checkPasswordVC.dismiss(animated: true) {
            self.walletWorker.remove(wallet: self.wallet)
            self.router.goToWalletsList()
        }
    }
}
