//  
//  WalletSettingsVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 20/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol WalletSettingsDisplayLogic: class {
    func handleUpdate(viewModel: WalletSettingsViewModel)
}

class WalletSettingsVC: ViewController, WalletSettingsDisplayLogic, UITableViewDelegate, CheckPasswordVCDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    let dataSource = WalletSettingsDataSource()
    
    let router: WalletSettingsRoutingLogic
    let interactor: WalletSettingsBusinessLogic
    
    let wallet: WalletModel
    
    // MARK: - View lifecycle
    
    init(wallet: WalletModel) {
        let interactor = WalletSettingsInteractor()
        let presenter = WalletSettingsPresenter()
        let router = WalletSettingsRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.wallet = wallet
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: WalletSettingsRoutingLogic, interactor: WalletSettingsBusinessLogic, wallet: WalletModel) {
        self.router = router
        self.interactor = interactor
        
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

        // Subviews
        view.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // TableView
        
        WalletSettingsCell.registerWith(tableView)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.backgroundColor = .clear
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_wallet_title(), subtitle: wallet.name)
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    // MARK: - Actions
    
    @objc func backTapped() {
        router.goBack()
    }

    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let titleView = self.navigationItem.titleView as? TitleView else { return }
            
            let vc = CheckPasswordVC(wallet: wallet, titleView: titleView, delegate: self)
            present(NavigationController(rootViewController: vc), animated: true, completion: nil)

        } else if indexPath.row == 1 {
            
        }
    }
    
    // MARK: - Check password delegate
    
    func didEnterPassword(checkPasswordVC: CheckPasswordVC, string: String) {
        guard let wp = wallet.password, string == wp else {
            return
        }
        
        checkPasswordVC.dismiss(animated: true) {
            self.router.showExportWallet(wallet: self.wallet)
        }
    }
    
    // MARK: UI Update
    
    func handleUpdate(viewModel: WalletSettingsViewModel) {
        
    }
}
