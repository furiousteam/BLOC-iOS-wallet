//  
//  ListPoolsVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ListPoolsDisplayLogic: class {
    func handleUpdate(viewModel: ListPoolsViewModel)
}

class ListPoolsVC: ViewController, ListPoolsDisplayLogic, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
        return tableView
    }()
    
    var refreshControl: RefreshControl!

    let dataSource = ListPoolsDataSource()
    
    let router: ListPoolsRoutingLogic
    let interactor: ListPoolsBusinessLogic
    
    var selectedPool: MiningPoolModel
    
    // MARK: - View lifecycle
    
    init(selectedPool: MiningPoolModel) {
        let interactor = ListPoolsInteractor()
        let presenter = ListPoolsPresenter()
        let router = ListPoolsRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.selectedPool = selectedPool
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: ListPoolsRoutingLogic, interactor: ListPoolsBusinessLogic, selectedPool: MiningPoolModel) {
        self.router = router
        self.interactor = interactor
        
        self.selectedPool = selectedPool
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactor.fetchPools()
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
        
        ListPoolsCell.registerWith(tableView)
        LoadingTableViewCell.registerWith(tableView)
        ErrorTableViewCell.registerWith(tableView)
        
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
        
        let titleView = TitleView(title: R.string.localizable.home_menu_mining_title(), subtitle: R.string.localizable.home_menu_mining_subtitle())
        self.navigationItem.titleView = titleView
        
        let addButton = UIBarButtonItem(image: R.image.addIcon(), style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.setRightBarButton(addButton, animated: false)
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    // MARK: - Actions
    
    @objc func refresh() {
        interactor.fetchPools()
    }
    
    @objc func addTapped() {
        router.showAddPool()
    }
    
    @objc func backTapped() {
        router.goBack()
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pool = dataSource.pools[indexPath.section] as? MiningPool {
            interactor.saveSelectedPool(pool: pool)
        }
    }

    // MARK: - UI Update
    
    func handleUpdate(viewModel: ListPoolsViewModel) {
        refreshControl.endRefreshing()
        
        switch viewModel.state {
        case .loaded(let pools):
            dataSource.isLoading = false
            dataSource.errorText = nil
            dataSource.pools = pools
            
            if dataSource.pools.count == 0 {
                CryptonightMiner.defaultMiningPools.forEach(interactor.addPool)
                
                interactor.fetchPools()
            }
        case .loading:
            dataSource.errorText = nil
            dataSource.isLoading = true
        case .error(let error):
            dataSource.errorText = error
            dataSource.isLoading = false
        }
        
        tableView.reloadData()
        
        DispatchQueue.main.async {
            if let poolIndex = self.dataSource.pools.index(where: { $0.host == self.selectedPool.host && $0.port == self.selectedPool.port }) {
                self.tableView.selectRow(at: IndexPath(row: 0, section: poolIndex), animated: false, scrollPosition: .none)
            }
        }
    }
}
