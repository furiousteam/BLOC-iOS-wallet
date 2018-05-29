//
//  TabBarVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import SnapKit

enum Tab: Int {
    case wallets = 0
    case send = 1
    case menu = 2
    case transactions = 3
    case news = 4
}

final class TabBarVC: ViewController {
    
    let walletsVC = ListWalletsVC()
    let sendVC = NewTransactionVC()
    let transactionsVC = ListTransactionsVC()
    let menuVC = HomeVC()
    let newsVC = ListNewsVC()
    
    let tabBar = TabBarView()
    let container = HomeContainer()
    let safeAreaFiller: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x000021)
        return view
    }()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        setControllers([ NavigationController(rootViewController: walletsVC),
                         NavigationController(rootViewController: sendVC),
                         menuVC,
                         NavigationController(rootViewController: transactionsVC),
                         NavigationController(rootViewController: newsVC) ])
        
        tabBar.didSelectTab = { [weak self] index in
            guard let tab = Tab(rawValue: index) else { return }
            
            self?.setSelectedTab(tab: tab)
        }
        
        container.didSelectTab = { [weak self] index in
            guard let tab = Tab(rawValue: index) else { return }
            
            self?.setSelectedTab(tab: tab)
        }
        
        NotificationCenter.default.addObserver(forName: .selectWalletTab, object: nil, queue: nil, using: handleSelectWalletTab)
        NotificationCenter.default.addObserver(forName: .selectNewsTab, object: nil, queue: nil, using: handleSelectNewsTab)
        NotificationCenter.default.addObserver(forName: .selectSendTab, object: nil, queue: nil, using: handleSelectSendTab)
        NotificationCenter.default.addObserver(forName: .selectTransactionsTab, object: nil, queue: nil, using: handleSelectTransactionsTab)
        NotificationCenter.default.addObserver(forName: .selectMenuTab, object: nil, queue: nil, using: handleSelectMenuTab)
    }
    
    // MARK: - Configuration
    
    override func configure() {
        super.configure()
        
        edgesForExtendedLayout = []
        
        container.view.clipsToBounds = true

        view.backgroundColor = .white
        
        view.addSubview(container.view)
        addChildViewController(container)
        
        view.addSubview(tabBar)
                
        container.view.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview()
            
            if #available(iOS 11, *) {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50.0)
            } else {
                $0.bottom.equalToSuperview().inset(50.0)
            }
        })
        
        tabBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(TabBarItem.height)
            
            if #available(iOS 11, *) {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.bottom.equalToSuperview()
            }
        }
        
        if #available(iOS 11, *) {
            view.addSubview(safeAreaFiller)
            
            safeAreaFiller.snp.makeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                $0.bottom.equalToSuperview()
            })
        }
    }
    
    func setControllers(_ controllers: [UIViewController]) {
        tabBar.items = controllers.map({ $0.tabBarItem })
        container.childControllers = controllers
    }
        
    func setSelectedTab(tab: Tab) {
        tabBar.setActiveTab(index: tab.rawValue)
        container.setSelectedIndex(index: tab.rawValue)
    }
    
    // MARK: - Actions
    
    @objc func handleSelectWalletTab(notification: Notification) {
        setSelectedTab(tab: .wallets)
    }
    
    @objc func handleSelectNewsTab(notification: Notification) {
        setSelectedTab(tab: .news)
    }
    
    @objc func handleSelectSendTab(notification: Notification) {
        setSelectedTab(tab: .send)
    }
    
    @objc func handleSelectTransactionsTab(notification: Notification) {
        setSelectedTab(tab: .transactions)
    }
    
    @objc func handleSelectMenuTab(notification: Notification) {
        setSelectedTab(tab: .menu)
    }
    
}

