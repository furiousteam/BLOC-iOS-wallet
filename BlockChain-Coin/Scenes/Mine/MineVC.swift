//
//  MineVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 08/02/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

protocol MineDisplayLogic: class {
    func handlePoolStatus(viewModel: PoolStatusViewModel)
    func handleMinerStats(viewModel: MinerStatsViewModel)
}

class MineVC: UIViewController, MineDisplayLogic, UITableViewDelegate {
    let poolClient = PoolSocketClient()
    let miner = CryptonightMiner()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let poolStatusView = PoolStatusView()
    
    let logo: UIImageView = {
        let imageView = UIImageView(image: R.image.logo())
        return imageView
    }()
    
    let mineButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        button.setTitleColor(UIColor(hex: 0x4A90E2), for: .normal)
        button.setTitleColor(UIColor(hex: 0xD0021B), for: .selected)
        button.setTitle("Start Mining", for: .normal)
        button.setTitle("Stop Mining", for: .selected)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(hex: 0xEEEEEE).cgColor
        return button
    }()

    let dataSource = MineDataSource()
    
    let router: MineRoutingLogic
    let interactor: MineBusinessLogic
    
    enum MiningStatus {
        case notMining
        case mining
    }
    
    var miningStatus: MiningStatus = .notMining {
        didSet {
            switch miningStatus {
            case .mining:
                mineButton.isSelected = true
            case .notMining:
                mineButton.isSelected = false
                dataSource.hashRate = 0.0
                dataSource.sharesFound = 0
                dataSource.totalHashes = 0
                tableView.reloadData()
            }
        }
    }

    // MARK: - View lifecycle
    
    init() {
        let interactor = MineInteractor()
        let presenter = MinePresenter()
        let router = MineRouter()
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
        handlePoolStatus(viewModel: PoolStatusViewModel(state: .disconnected, address: nil))
    }
    
    // MARK: - Configuration
    
    func configure() {
        // Subviews
        view.backgroundColor = .white
        
        view.addSubview(logo)
        
        logo.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(80.0)
        })
        
        view.addSubview(poolStatusView)
        
        poolStatusView.snp.makeConstraints({
            $0.leading.trailing.top.equalToSuperview()
        })
        
        view.addSubview(mineButton)
        
        mineButton.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(55.0)
        })
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(poolStatusView.snp.bottom)
            $0.bottom.equalTo(mineButton.snp.top)
        })
        
        // TableView
        
        MineStatCell.registerWith(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        // Actions
        
        mineButton.addTarget(self, action: #selector(mineTapped), for: .touchUpInside)
    }
    
    // MARK: - Display logic
    
    func handlePoolStatus(viewModel: PoolStatusViewModel) {
        switch viewModel.state {
        case .error(let error):
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .text
            hud.label.text = error
            hud.hide(animated: true, afterDelay: 3.0)
        default:
            break
        }
        
        poolStatusView.configure(status: viewModel.state.text, address: viewModel.address)

        switch viewModel.state {
        case .disconnected, .error:
            miningStatus = .notMining
        default:
            miningStatus = .mining
        }
    }
    
    func handleMinerStats(viewModel: MinerStatsViewModel) {
        dataSource.hashRate = viewModel.hashRate > 0 ? viewModel.hashRate : dataSource.hashRate
        dataSource.totalHashes = viewModel.totalHashes
        dataSource.sharesFound = viewModel.sharesFound
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func mineTapped() {
        switch miningStatus {
        case .mining:
            interactor.disconnect()
        case .notMining:
            interactor.connect(host: "miningpool.blockchain-coin.net",
                               port: 4444,
                               wallet: "b12iFt4XPAu96TUCAXjdznDa3KUWQ1bq4djYZGARRp6b3KYj3RtQeykaXiKC6rqJYk4PiD6qCorWE2i9FCi1Gr8Z29E3Rqx1r")
        }
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
