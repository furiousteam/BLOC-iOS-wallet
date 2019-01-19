//  
//  ShowMiningStatsVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 02/04/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ShowMiningStatsDisplayLogic: class {
    func handleUpdate(viewModel: ShowMiningStatsViewModel)
}

class ShowMiningStatsVC: ViewController, ShowMiningStatsDisplayLogic {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
        return tableView
    }()
    
    var refreshControl: RefreshControl!

    let dataSource = ShowMiningStatsDataSource()
    
    let router: ShowMiningStatsRoutingLogic
    let interactor: ShowMiningStatsBusinessLogic
    
    let settings: MiningSettingsModel
    
    // MARK: - View lifecycle
    
    init(settings: MiningSettingsModel) {
        let interactor = ShowMiningStatsInteractor()
        let presenter = ShowMiningStatsPresenter()
        let router = ShowMiningStatsRouter()
        
        self.settings = settings
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: ShowMiningStatsRoutingLogic, interactor: ShowMiningStatsBusinessLogic, settings: MiningSettingsModel) {
        self.router = router
        self.interactor = interactor
        
        self.settings = settings
        
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
        
        ShowMiningStatsCell.registerWith(tableView)
        LoadingTableViewCell.registerWith(tableView)
        ErrorTableViewCell.registerWith(tableView)
        
        tableView.dataSource = dataSource
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
        
        let titleView = TitleView(title: R.string.localizable.home_menu_mining_title(), subtitle: R.string.localizable.home_menu_mining_subtitle())
        self.navigationItem.titleView = titleView
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        interactor.fetchStats(settings: settings)
    }
    
    // MARK: - Actions
    
    @objc func backTapped() {
        router.goBack()
    }
    
    @objc func refresh() {
        interactor.fetchStats(settings: settings)
    }

    // MARK: UI Update
    
    func handleUpdate(viewModel: ShowMiningStatsViewModel) {
        refreshControl.endRefreshing()
        
        switch viewModel.state {
        case .loaded(let stats):
            dataSource.isLoading = false
            dataSource.errorText = nil
            dataSource.poolStats = stats.poolStats
            dataSource.addressStats = stats.addressStats
        case .loading:
            dataSource.errorText = nil
            dataSource.isLoading = true
        case .error(let error):
            dataSource.errorText = error
            dataSource.isLoading = false
        }
        
        tableView.reloadData()
    }
}
