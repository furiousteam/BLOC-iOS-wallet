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

class ListWalletsVC: UIViewController, ListWalletsDisplayLogic, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
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
    
    func configure() {
        // Subviews
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // TableView
        
        ListWalletsCell.registerWith(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.estimatedRowHeight = 60.0
        
        // Actions
        
        let addWalletButton = UIBarButtonItem(image: R.image.add(), style: .plain, target: self, action: #selector(addWalletTapped))
        self.navigationItem.setRightBarButton(addWalletButton, animated: false)
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
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
        router.showAddWallet()
    }
    
    @objc func backTapped() {
        router.goBack()
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        router.showWallet(wallet: dataSource.wallets[indexPath.section])
    }
    
}
