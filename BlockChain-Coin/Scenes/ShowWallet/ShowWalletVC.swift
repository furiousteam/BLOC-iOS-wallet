//
//  ShowWalletVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 14/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import MBProgressHUD

protocol ShowWalletDisplayLogic: class {
    func handleUpdate(viewModel: ShowWalletDetailsViewModel)
}

class ShowWalletVC: UIViewController, ShowWalletDisplayLogic, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let wallet: WalletModel
    
    let transactionService = TransactionDiskStore()
    
    let dataSource = ShowWalletDataSource()
    
    let router: ShowWalletRoutingLogic
    let interactor: ShowWalletBusinessLogic
    
    // MARK: - View lifecycle
    
    init(wallet: WalletModel) {
        let interactor = ShowWalletInteractor()
        let presenter = ShowWalletPresenter()
        let router = ShowWalletRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.wallet = wallet
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        self.title = "Wallet details"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor.fetchDetails(address: wallet.address)
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
        
        ShowWalletTransactionHeaderView.registerWith(tableView)
        ShowWalletCell.registerWith(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.estimatedRowHeight = 60.0
    }
    
    // MARK: - Display logic
    
    func handleUpdate(viewModel: ShowWalletDetailsViewModel) {
        // TODO: Loading state
        // TODO: Error state
        
        switch viewModel.state {
        case .loaded(let details):
            let availableBalance = Balance(value: Double(details.availableBalance) / Constants.walletCurrencyDivider, balanceType: .available)
            let lockedBalance = Balance(value: Double(details.lockedBalance) / Constants.walletCurrencyDivider, balanceType: .locked)

            dataSource.balances = [ availableBalance, lockedBalance ]
            dataSource.transactions = details.transactions
        default:
            break
        }
        
        tableView.reloadData()
    }
        
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= dataSource.balances.count {
            return 25.0
        }
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= dataSource.balances.count {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShowWalletTransactionHeaderView.reuseIdentifier()) as! ShowWalletTransactionHeaderView
            headerView.configure()
            return headerView
        }
        
        return nil
    }
        
}

