//
//  ListWalletsVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

protocol ListWalletsDisplayLogic: class {
    func handleWalletsUpdate(viewModel: ListWalletsViewModel)
}

class ListWalletsVC: ViewController, ListWalletsDisplayLogic, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
        return tableView
    }()
        
    let dataSource = ListWalletsDataSource()
    
    let router: ListWalletsRoutingLogic
    let interactor: ListWalletsBusinessLogic
    
    // MARK: - View lifecycle
    
    init() {
        let interactor = ListWalletsInteractor()
        let presenter = ListWalletsPresenter()
        let router = ListWalletsRouter()
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        self.title = "My Wallets"
        
        commonInit()
    }
    
    func commonInit() {
        tabBarItem = UITabBarItem(title: R.string.localizable.tabs_wallet(), image: R.image.tabBarWallet(), selectedImage: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor.fetchWallets()
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
        
        ListWalletsCell.registerWith(tableView)
        NoWalletTitleCell.registerWith(tableView)
        NoWalletInstructionsCell.registerWith(tableView)
        ActionCell.registerWith(tableView)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.backgroundColor = .clear
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_wallet_title(), subtitle: R.string.localizable.home_menu_wallet_subtitle())
        self.navigationItem.titleView = titleView
        
        let addWalletButton = UIBarButtonItem(image: R.image.addIcon(), style: .plain, target: self, action: #selector(addWalletTapped))
        self.navigationItem.setRightBarButton(addWalletButton, animated: false)
        
        let menuButton = UIBarButtonItem(image: R.image.menuIcon(), style: .plain, target: self, action: #selector(menuTapped))
        self.navigationItem.setLeftBarButton(menuButton, animated: false)
    }
    
    // MARK: - Display logic
    
    func handleWalletsUpdate(viewModel: ListWalletsViewModel) {
        // TODO: Loading state
        // TODO: Error state
        
        switch viewModel.state {
        case .loaded(let wallets):
            dataSource.wallets = wallets
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func addWalletTapped() {
        if dataSource.wallets.count > 1 {
            let createAlert = CreateWalletAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            createAlert.setup(title: nil, message: nil)
            
            createAlert.didTapNewWallet = { [weak self] in
                DispatchQueue.main.async {
                    self?.router.showAddWallet()
                }
            }
            
            createAlert.didTapImportWalletWithKey = { [weak self] in
                DispatchQueue.main.async {
                    self?.router.showImportWalletWithKey()
                }
            }
            
            createAlert.didTapImportWalletWithQRCode = { [weak self] in
                DispatchQueue.main.async {
                    self?.router.showImportWalletWithQRCode()
                }
            }
            
            self.present(createAlert, animated: true, completion: nil)
        } else {
            router.showAddWallet()
        }
    }
    
    @objc func backTapped() {
        router.goBack()
    }
    
    @objc func menuTapped() {
        router.showHome()
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if dataSource.wallets.count == 0 {
            if indexPath.row == 0 {
                router.showAddWallet()
            } else if indexPath.row == 1 {
                router.showImportWalletWithKey()
            } else if indexPath.row == 2 {
                router.showImportWalletWithQRCode()
            }
        } else {
            router.showWallet(wallet: dataSource.wallets[indexPath.section])
        }
    }
    
}
