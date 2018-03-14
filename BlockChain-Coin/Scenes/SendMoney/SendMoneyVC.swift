//  
//  SendMoneyVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol SendMoneyDisplayLogic: class {
    func handleUpdate(viewModel: SendMoneyViewModel)
}

class SendMoneyVC: ViewController, SendMoneyDisplayLogic {
    
    let dataSource = SendMoneyDataSource()
    
    let router: SendMoneyRoutingLogic
    let interactor: SendMoneyBusinessLogic
    
    // MARK: - View lifecycle
    
    init() {
        let interactor = SendMoneyInteractor()
        let presenter = SendMoneyPresenter()
        let router = SendMoneyRouter()
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        tabBarItem = UITabBarItem(title: R.string.localizable.tabs_send(), image: R.image.tabBarSend(), selectedImage: nil)
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
    
    func handleUpdate(viewModel: SendMoneyViewModel) {
        
    }
}
