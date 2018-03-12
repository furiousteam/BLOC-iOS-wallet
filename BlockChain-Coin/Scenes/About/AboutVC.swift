//  
//  AboutVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol AboutDisplayLogic: class {
    func handleUpdate(viewModel: AboutViewModel)
}

class AboutVC: ViewController, AboutDisplayLogic {
    
    let dataSource = AboutDataSource()
    
    let router: AboutRoutingLogic
    let interactor: AboutBusinessLogic
    
    // MARK: - View lifecycle
    
    init() {
        let interactor = AboutInteractor()
        let presenter = AboutPresenter()
        let router = AboutRouter()
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: AboutRoutingLogic, interactor: AboutBusinessLogic) {
        self.router = router
        self.interactor = interactor
        
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
    }

    // MARK: UI Update
    
    func handleUpdate(viewModel: AboutViewModel) {
        
    }
}
