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
    case mining = 1
    case about = 2
    case send = 3
    case transactions = 4
}

final class TabBarVC: ViewController {
    
    let walletsVC = ListWalletsVC()
    let miningVC = MineVC()
    let sendVC = SendMoneyVC()
    let transactionsVC = ListTransactionsVC()
    let aboutVC = AboutVC()
    
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
                         NavigationController(rootViewController: miningVC),
                         NavigationController(rootViewController: aboutVC),
                         NavigationController(rootViewController: sendVC),
                         NavigationController(rootViewController: transactionsVC) ])
        
        tabBar.didSelectTab = { [weak self] index in
            guard let tab = Tab(rawValue: index) else { return }
            
            self?.setSelectedTab(tab: tab)
        }
        
        container.didSelectTab = { [weak self] index in
            guard let tab = Tab(rawValue: index) else { return }
            
            self?.setSelectedTab(tab: tab)
        }
    }
    
    // MARK: - Configuration
    
    fileprivate func configure() {
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
    
}

