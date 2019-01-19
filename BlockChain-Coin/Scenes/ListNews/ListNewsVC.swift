//  
//  ListNewsVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 05/05/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ListNewsDisplayLogic: class {
    func handleUpdate(viewModel: ListNewsViewModel)
}

class ListNewsVC: ViewController, ListNewsDisplayLogic, UITableViewDelegate {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 30.0, right: 0.0)
        return tableView
    }()
    
    var refreshControl: RefreshControl!

    let dataSource = ListNewsDataSource()
    
    let router: ListNewsRoutingLogic
    let interactor: ListNewsBusinessLogic
    
    // MARK: - View lifecycle
    
    init() {
        let interactor = ListNewsInteractor()
        let presenter = ListNewsPresenter()
        let router = ListNewsRouter()
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        commonInit()
    }
    
    init(router: ListNewsRoutingLogic, interactor: ListNewsBusinessLogic) {
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func commonInit() {
        tabBarItem = UITabBarItem(title: R.string.localizable.tabs_news(), image: R.image.tabBarNews(), selectedImage: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        ListNewsCell.registerWith(tableView)
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
        
        let titleView = TitleView(title: R.string.localizable.home_menu_news_title(), subtitle: R.string.localizable.home_menu_news_subtile())
        self.navigationItem.titleView = titleView
        
        let menuButton = UIBarButtonItem(image: R.image.menuIcon(), style: .plain, target: self, action: #selector(menuTapped))
        self.navigationItem.setLeftBarButton(menuButton, animated: false)
    }
    
    // MARK: - Actions
    
    @objc func refresh() {
        interactor.fetchNews()
    }
    
    @objc func menuTapped() {
        router.showHome()
    }

    // MARK: UI Update
    
    func handleUpdate(viewModel: ListNewsViewModel) {
        refreshControl.endRefreshing()
        
        switch viewModel.state {
        case .loaded(let news):
            dataSource.news = news
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
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard dataSource.isLoading == false, dataSource.errorText == nil else { return }
        
        let news = dataSource.news[indexPath.section]
        
        router.showNews(news: news)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
