//  
//  ListTransactionsVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
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

    var refreshControl: RefreshControl!

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
        
        refresh()
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
        
        ListTransactionsCell.registerWith(tableView)
        LoadingTableViewCell.registerWith(tableView)
        ErrorTableViewCell.registerWith(tableView)
        NoTransactionsCell.registerWith(tableView)
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0
        tableView.backgroundColor = .clear
        
        refreshControl = RefreshControl(target: self, action: #selector(refresh))
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }

        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_transactions_title(), subtitle: R.string.localizable.home_menu_transactions_subtitle())
        self.navigationItem.titleView = titleView
        
        if let _ = wallets {
            let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
            self.navigationItem.setLeftBarButton(backButton, animated: false)
        } else {
            let menuButton = UIBarButtonItem(image: R.image.menuIcon(), style: .plain, target: self, action: #selector(menuTapped))
            self.navigationItem.setLeftBarButton(menuButton, animated: false)
        }
    }
    
    // MARK: - Actions
    
    @objc func refresh() {
        if let wallets = wallets {
            interactor.fetchTransactions(forWallets: wallets)
        } else {
            interactor.fetchAllTransactions()
        }
    }

    @objc func menuTapped() {
        router.showHome()
    }
    
    @objc func backTapped() {
        router.goBack()
    }

    // MARK: - UI Update
    
    func handleUpdate(viewModel: ListTransactionsViewModel) {
        refreshControl.endRefreshing()
        
        switch viewModel.state {
        case .loaded(let transactions):
            dataSource.transactions = transactions
            dataSource.isLoading = false
            dataSource.errorText = nil
        case .loading:
            dataSource.errorText = nil
            dataSource.isLoading = true
        case .error(let error):
            dataSource.errorText = error
            dataSource.isLoading = false
        }
        
        tableView.reloadData()
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard dataSource.isLoading == false, dataSource.errorText == nil else { return }
        
        let transaction = dataSource.transactions[indexPath.section]
        
        router.showTransaction(transaction: transaction)
    }
}
