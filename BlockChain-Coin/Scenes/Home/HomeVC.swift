//  
//  HomeVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol HomeDisplayLogic: class {
}

class HomeVC: ViewController, UITableViewDelegate, HomeDisplayLogic {
    
    let dataSource = HomeDataSource()
    
    let router: HomeRoutingLogic
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.defaultBg()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.logoSmall()
        imageView.tintColor = .white
        imageView.contentMode = .center
        return imageView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()

    // MARK: - View lifecycle
    
    init() {
        let router = HomeRouter()
        
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
        
        router.viewController = self
    }
    
    init(router: HomeRoutingLogic) {
        self.router = router
        
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
    
    func configure() {
        view.backgroundColor = .white
        
        // Subviews
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints({
            $0.top.equalTo(110.0)
            $0.centerX.equalToSuperview()
        })
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(logoImageView.snp.bottom).offset(55.0)
            $0.left.right.bottom.equalToSuperview()
        })
        
        // TableView
        
        HomeCell.registerWith(tableView)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.delegate = self
        tableView.allowsMultipleSelection = true
        
        dataSource.items = [ [ HomeItem(title: R.string.localizable.home_menu_wallet_title(), subtitle: R.string.localizable.home_menu_wallet_subtitle()),
                               HomeItem(title: R.string.localizable.home_menu_mining_title(), subtitle: R.string.localizable.home_menu_mining_subtitle()),
                               HomeItem(title: R.string.localizable.home_menu_send_title(), subtitle: R.string.localizable.home_menu_send_subtitle()),
                               HomeItem(title: R.string.localizable.home_menu_transactions_title(), subtitle: R.string.localizable.home_menu_transactions_subtitle()),
                               HomeItem(title: R.string.localizable.home_menu_about_title(), subtitle: R.string.localizable.home_menu_about_subtitle()) ] ]
    }
    
    // MARK: TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Route to corresponding scene
    }
}
