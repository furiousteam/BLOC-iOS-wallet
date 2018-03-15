//  
//  ImportWalletKeyVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol ImportWalletKeyDisplayLogic: class {
    func handleUpdate(viewModel: ImportWalletKeyViewModel)
}

class ImportWalletKeyVC: ViewController, ImportWalletKeyDisplayLogic {
        
    let router: ImportWalletKeyRoutingLogic
    let interactor: ImportWalletKeyBusinessLogic
    
    // MARK: - View lifecycle
    
    init() {
        let interactor = ImportWalletKeyInteractor()
        let presenter = ImportWalletKeyPresenter()
        let router = ImportWalletKeyRouter()
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: ImportWalletKeyRoutingLogic, interactor: ImportWalletKeyBusinessLogic) {
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
    
    func handleUpdate(viewModel: ImportWalletKeyViewModel) {
        
    }
}
