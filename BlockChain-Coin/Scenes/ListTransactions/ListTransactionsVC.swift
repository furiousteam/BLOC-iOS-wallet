//  
//  ListTransactionsVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ListTransactionsDisplayLogic: class {
    func handleUpdate(viewModel: ListTransactionsViewModel)
}

class ListTransactionsVC: ViewController, ListTransactionsDisplayLogic, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 30.0, right: 0.0)
        return tableView
    }()

    let dataSource = ListTransactionsDataSource()
    
    let router: ListTransactionsRoutingLogic
    let interactor: ListTransactionsBusinessLogic
    
    let wallets: [WalletModel]?
    
    // MARK: - View lifecycle
    
    init(wallets: [WalletModel]? = nil) {
        let interactor = ListTransactionsInteractor()
        let presenter = ListTransactionsPresenter()
        let router = ListTransactionsRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.wallets = wallets
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        commonInit()
    }
    
    init(router: ListTransactionsRoutingLogic, interactor: ListTransactionsBusinessLogic, wallets: [WalletModel]?) {
        self.router = router
        self.interactor = interactor
        
        self.wallets = wallets
        
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    func commonInit() {
        tabBarItem = UITabBarItem(title: R.string.localizable.tabs_transactions(), image: R.image.tabBarTransactions(), selectedImage: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        if let wallets = wallets {
            interactor.fetchTransactions(forWallets: wallets)
        } else {
            interactor.fetchAllTransactions()
        }
    }

    // MARK: - Configuration
    
    func configure() {
        // Subviews
        view.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // TableView
        
        ListTransactionsCell.registerWith(tableView)
        ListTransactionsEmptyCell.registerWith(tableView)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.backgroundColor = .clear
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_transactions_title(), subtitle: R.string.localizable.home_menu_transactions_subtitle())
        self.navigationItem.titleView = titleView
                
        let menuButton = UIBarButtonItem(image: R.image.menuIcon(), style: .plain, target: self, action: #selector(menuTapped))
        self.navigationItem.setLeftBarButton(menuButton, animated: false)
    }
    
    // MARK: - Actions
    
    @objc func menuTapped() {
        router.showHome()
    }

    // MARK: - UI Update
    
    func handleUpdate(viewModel: ListTransactionsViewModel) {
        // TODO: Loading state
        // TODO: Error state
        
        switch viewModel.state {
        case .loaded(let transactions):
            dataSource.transactions = transactions
        default:
            break
        }
        
        tableView.reloadData()
    }
}
