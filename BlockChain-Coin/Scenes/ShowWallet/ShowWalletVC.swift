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
import EFQRCode

protocol ShowWalletDisplayLogic: class {
    func handleUpdate(viewModel: ShowWalletDetailsViewModel)
}

class ShowWalletVC: ViewController, ShowWalletDisplayLogic, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
        return tableView
    }()
    
    var refreshControl: RefreshControl!
    
    var hud: MBProgressHUD?
    
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
        
        interactor.fetchDetails(wallet: wallet, password: wallet.password ?? "")
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
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_wallet_title(), subtitle: R.string.localizable.home_menu_wallet_subtitle())
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)

        let settingsButton = UIBarButtonItem(image: R.image.settingsIcon(), style: .plain, target: self, action: #selector(settingsTapped))
        self.navigationItem.setRightBarButtonItems([ settingsButton ], animated: false)

        // TableView
        
        ShowWalletBalanceCell.registerWith(tableView)
        ShowWalletExportKeysCell.registerWith(tableView)
        ShowWalletTransactionsHeaderCell.registerWith(tableView)
        ShowWalletTransactionCell.registerWith(tableView)
        LoadingTableViewCell.registerWith(tableView)
        ErrorTableViewCell.registerWith(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.estimatedRowHeight = 60.0
        
        refreshControl = RefreshControl(target: self, action: #selector(refresh))
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        // Actions
        
        dataSource.didTapQRCode = { self.showAddressAsQRCode() }
        dataSource.didTapCopy = { self.copyAddress() }
        dataSource.didTapFullHistory = { self.showFullHistory() }
    }
    
    // MARK: - Actions
    
    @objc func refresh() {
        interactor.fetchDetails(wallet: wallet, password: wallet.password ?? "")
    }

    @objc func settingsTapped() {
        router.showSettings(wallet: wallet)
    }
    
    @objc func backTapped() {
        router.goBack()
    }
    
    @objc func showFullHistory() {
        router.showTransactionsHistory(wallet: wallet)
    }
    
    func showAddressAsQRCode() {
        if let qrCode = EFQRCode.generate(content: wallet.address, size: EFIntSize(width: Int(200 * UIScreen.main.scale), height: Int(200 * UIScreen.main.scale)), backgroundColor: UIColor.black.cgColor, foregroundColor: UIColor.white.cgColor, watermark: nil), let window = UIApplication.shared.keyWindow {
            self.hud = MBProgressHUD.showAdded(to: window, animated: true)
            hud?.mode = .customView
            
            let imageView = UIImageView(image: UIImage(cgImage: qrCode))
            
            imageView.snp.makeConstraints({
                $0.width.height.equalTo(200.0)
            })
            
            hud?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            hud?.customView = imageView
            hud?.bezelView.backgroundColor = .black
            hud?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideHud)))
        }
    }
    
    @objc func hideHud() {
        hud?.hide(animated: true)
    }
    
    func copyAddress() {
        UIPasteboard.general.string = wallet.address
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        hud.label.text = R.string.localizable.wallet_address_copied()
        hud.hide(animated: true, afterDelay: 2.0)
    }
    
    // MARK: - Display logic
    
    func handleUpdate(viewModel: ShowWalletDetailsViewModel) {
        switch viewModel.state {
        case .loaded(let details):
            let availableBalance = Balance(value: Double(details.availableBalance) / Constants.walletCurrencyDivider, balanceType: .available)
            let lockedBalance = Balance(value: Double(details.lockedBalance) / Constants.walletCurrencyDivider, balanceType: .locked)

            dataSource.wallet = wallet
            dataSource.balances = [ availableBalance, lockedBalance ]
            dataSource.transactions = Array(details.transactions.prefix(10))
            dataSource.isLoading = false
        case .loading:
            dataSource.errorText = nil
            dataSource.isLoading = true
        case .error(let error):
            dataSource.errorText = error
            dataSource.isLoading = false
        default:
            break
        }
        
        refreshControl.endRefreshing()
        
        tableView.reloadData()
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Handle row selection
    }
}

