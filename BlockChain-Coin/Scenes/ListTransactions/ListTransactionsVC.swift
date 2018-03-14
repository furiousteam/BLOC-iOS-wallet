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

class ListTransactionsVC: ViewController, ListTransactionsDisplayLogic {
    
    let dataSource = ListTransactionsDataSource()
    
    let router: ListTransactionsRoutingLogic
    let interactor: ListTransactionsBusinessLogic
    
    // MARK: - View lifecycle
    
    init() {
        let interactor = ListTransactionsInteractor()
        let presenter = ListTransactionsPresenter()
        let router = ListTransactionsRouter()
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        commonInit()
    }
    
    init(router: ListTransactionsRoutingLogic, interactor: ListTransactionsBusinessLogic) {
        self.router = router
        self.interactor = interactor
        
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
    }

    // MARK: - Configuration
    
    func configure() {
        view.backgroundColor = .white
    }

    // MARK: UI Update
    
    func handleUpdate(viewModel: ListTransactionsViewModel) {
        
    }
}
