//
//  CreateWalletVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 13/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

protocol CreateWalletDisplayLogic: class {
    func handleWalletCreateUpdate(viewModel: CreateWalletViewModel)
}

class CreateWalletVC: UIViewController, CreateWalletDisplayLogic, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    weak var progressHUD: MBProgressHUD?
    
    let dataSource = CreateWalletDataSource()
    
    let router: CreateWalletRoutingLogic
    let interactor: CreateWalletBusinessLogic
    
    // MARK: - View lifecycle
    
    init() {
        let interactor = CreateWalletInteractor()
        let presenter = CreateWalletPresenter()
        let router = CreateWalletRouter()
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        self.title = "Create or restore a Wallet"
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
        // Subviews
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // TableView
        
        CreateWalletCell.registerWith(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    // MARK: - Display logic
    
    func handleWalletCreateUpdate(viewModel: CreateWalletViewModel) {
        switch viewModel.state {
        case .creating:
            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD?.mode = .indeterminate
            progressHUD?.label.text = "Creating wallet..."
        case .error(let error):
            progressHUD?.hide(animated: true)
            progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD?.mode = .text
            progressHUD?.detailsLabel.text = error
            progressHUD?.hide(animated: true, afterDelay: 2.0)
        case .created(let mnemonic, let address):
            progressHUD?.hide(animated: true)
            router.showMnemonic(mnemonic: mnemonic, address: address)
        }
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            interactor.createWallet()
        } else if indexPath.row == 1 {
            router.showRestoreWallet()
        }
    }
    
}

