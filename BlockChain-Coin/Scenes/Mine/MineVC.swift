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
import AVKit
import SwiftyGif

protocol MineDisplayLogic: class {
    func handleUpdate(viewModel: MineViewModel)
    func handlePoolStatus(viewModel: PoolStatusViewModel)
    func handleMinerStats(viewModel: MinerStatsViewModel)
    func handleOtherMinerStats(viewModel: OtherMinerStatsViewModel)
    func handleAddressMinerStats(viewModel: AddressMiningStatsViewModel)
    func handleJobSubmitted()
}

class MineVC: ViewController, MineDisplayLogic, UITableViewDelegate, SwiftyGifDelegate {
    var settings: MiningSettingsModel?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var lowPowerVC: MineLowPowerVC?
    
    let dataSource = MineDataSource()
    
    let router: MineRoutingLogic
    let interactor: MineBusinessLogic
    
    let introItem = AVPlayerItem(url: R.file.introMov()!)
    let loopItem = AVPlayerItem(url: R.file.loopMov()!)
    let videoBackgroundQueue: AVQueuePlayer
    let videoBackgroundLayer: AVPlayerLayer
    
    var stopAnimationOnNextLoop: Bool = false

    let gifManager = SwiftyGifManager(memoryLimit: 100)
    let outroGif = UIImage(gifName: "outro.gif")

    let outroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var statsTimer: Timer?
    var idleTimer: Timer?
    var globalTap: UITapGestureRecognizer?
    var keepMiningUIActive = false
    
    enum MiningStatus {
        case notMining
        case resetting
        case mining
    }
    
    var miningStatus: MiningStatus = .notMining {
        didSet {
            switch miningStatus {
            case .mining, .resetting:
                self.videoBackgroundQueue.play()
                
                self.outroImageView.stopAnimatingGif()
                self.outroImageView.isHidden = true

                UIApplication.shared.isIdleTimerDisabled = true
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                resetIdleTimer()
            case .notMining:
                idleTimer?.invalidate()

                if self.videoBackgroundQueue.rate > 0.0 {
                    self.outroImageView.isHidden = false
                    self.outroImageView.startAnimatingGif()
                    
                    NotificationCenter.default.post(name: Notification.Name("miningSwitchEnable"), object: false)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                        self.stopAnimationOnNextLoop = true
                        
                        self.videoBackgroundQueue.pause()
                        self.videoBackgroundQueue.removeAllItems()
                        self.videoBackgroundQueue.insert(self.introItem, after: nil)
                        self.videoBackgroundQueue.insert(self.loopItem, after: self.introItem)
                        self.videoBackgroundQueue.actionAtItemEnd = .advance
                        self.videoBackgroundQueue.seek(to: kCMTimeZero)
                    })
                }

                UIApplication.shared.isIdleTimerDisabled = false
                dataSource.hashRate = 0.0
                dataSource.sharesFound = 0
                dataSource.totalHashes = 0
                tableView.reloadData()
                
                self.navigationItem.rightBarButtonItem?.isEnabled = false
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
        
        self.videoBackgroundQueue = AVQueuePlayer(items: [ introItem, loopItem ])
        self.videoBackgroundQueue.isMuted = true

        self.videoBackgroundLayer = AVPlayerLayer(player: videoBackgroundQueue)
        self.videoBackgroundLayer.videoGravity = .resizeAspectFill
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
        
        commonInit()
    }
    
    func commonInit() {
        tabBarItem = UITabBarItem(title: R.string.localizable.tabs_mining(), image: R.image.tabBarMining(), selectedImage: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
        handlePoolStatus(viewModel: PoolStatusViewModel(state: .disconnected, address: nil))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(R.image.navBarTransparentBg(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true

        if let _ = lowPowerVC, miningStatus == .mining {
            self.videoBackgroundQueue.play()
        }
        
        interactor.fetchSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.lowPowerVC = nil
        
        resetIdleTimer()
        
        statsTimer?.invalidate()
        statsTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { timer in
            if let settings = self.dataSource.settings {
                self.interactor.fetchStats(settings: settings)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(R.image.navBarBg(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
        
        if lowPowerVC == nil {
            statsTimer?.invalidate()
        }
        
        idleTimer?.invalidate()
    }
    
    // MARK: - Configuration
    
    override func configure() {
        // Subviews
        
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = R.image.defaultBg()
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        outroImageView.setGifImage(outroGif, manager: gifManager, loopCount: -1)
        outroImageView.delegate = self
        outroImageView.stopAnimatingGif()

        view.addSubview(backgroundImageView)
        
        backgroundImageView.layer.addSublayer(videoBackgroundLayer)

        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        view.addSubview(outroImageView)

        outroImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        view.layoutSubviews()
        
        videoBackgroundLayer.frame = self.view.bounds

        view.backgroundColor = .white
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: introItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: loopItem)
        NotificationCenter.default.addObserver(forName: .loginMining, object: nil, queue: nil, using: handleLoginMining)

        // TableView
        
        MineSettingsCell.registerWith(tableView)
        MiningBootCell.registerWith(tableView)
        NoWalletTitleCell.registerWith(tableView)
        NoWalletInstructionsCell.registerWith(tableView)
        ActionCell.registerWith(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60.0

        dataSource.didChangeSwitch = { isOn in
            guard let settings = self.dataSource.settings else { return }
            
            switch self.miningStatus {
            case .mining, .resetting:
                self.interactor.disconnect()
            case .notMining:
                self.interactor.connect(host: settings.pool.host,
                                        port: settings.pool.port,
                                        wallet: settings.wallet.address)
                break
            }

            self.miningStatus = isOn ? .mining : .notMining
        }
        
        dataSource.didTapStats = {
            self.showStats()
        }
        
        NotificationCenter.default.addObserver(forName: .playMiningVideo, object: nil, queue: nil, using: playMiningVideoIfNeeded)
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_mining_title(), subtitle: R.string.localizable.home_menu_mining_subtitle())
        self.navigationItem.titleView = titleView
        
        let menuButton = UIBarButtonItem(image: R.image.menuIcon(), style: .plain, target: self, action: #selector(menuTapped))
        self.navigationItem.setLeftBarButton(menuButton, animated: false)
        
        let lowPowerButton = UIBarButtonItem(image: R.image.lowPower(), style: .plain, target: self, action: #selector(lowPowerTapped))
        self.navigationItem.setRightBarButton(lowPowerButton, animated: false)
    }
    
    @objc func handleLoginMining(notification: Notification) {
        resetMiner()
    }
    
    func stopMining() {
        if miningStatus == .mining {
            self.interactor.disconnect()
            
            NotificationCenter.default.post(name: Notification.Name("miningSwitchChangeState"), object: nil)
        }
    }
    
    @objc func playMiningVideoIfNeeded(notification: Notification) {
        if miningStatus == .mining {
            videoBackgroundQueue.play()
        }
    }
    
    func gifDidLoop(sender: UIImageView) {
        self.outroImageView.isHidden = true
        
        NotificationCenter.default.post(name: Notification.Name("miningSwitchEnable"), object: true)
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        switch miningStatus {
        case .mining, .resetting:
            if let item = notification.object as? AVPlayerItem, item == loopItem {
                item.seek(to: kCMTimeZero)
                videoBackgroundQueue.play()
            } else if let item = notification.object as? AVPlayerItem, item == introItem {
                videoBackgroundQueue.actionAtItemEnd = .none
            }
        case .notMining:
            break
        }
    }
    
    func resetMiner() {
        if let _ = dataSource.settings, miningStatus == .mining {
            log.info("Resetting miner")
            
            self.miningStatus = .resetting
            
            self.interactor.disconnect()
        }
    }
    
    // MARK: - Display logic
    
    func handlePoolStatus(viewModel: PoolStatusViewModel) {
        switch viewModel.state {
        case .error(let error):
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .text
            hud.detailsLabel.text = error
            hud.hide(animated: true, afterDelay: 3.0)
        default:
            break
        }
        
        switch viewModel.state {
        case .disconnected:
            if let settings = dataSource.settings, miningStatus == .resetting {
                self.interactor.connect(host: settings.pool.host,
                                        port: settings.pool.port,
                                        wallet: settings.wallet.address)
            } else {
                miningStatus = .notMining
            }
        case .error:
            miningStatus = .notMining
        default:
            miningStatus = .mining
        }
    }
    
    func handleMinerStats(viewModel: MinerStatsViewModel) {
        dataSource.hashRate = viewModel.hashRate > 0 ? viewModel.hashRate : dataSource.hashRate
        dataSource.totalHashes = viewModel.totalHashes
        dataSource.sharesFound = viewModel.sharesFound
        
        lowPowerVC?.configure(hashRate: dataSource.hashRate, totalHashes: dataSource.totalHashes, sharesFound: dataSource.sharesFound, activeMiners: dataSource.activeMiners, pendingBalance: dataSource.pendingBalance)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleOtherMinerStats(viewModel: OtherMinerStatsViewModel) {
        dataSource.activeMiners = UInt(viewModel.stats.miners)
        
        lowPowerVC?.configure(hashRate: dataSource.hashRate, totalHashes: dataSource.totalHashes, sharesFound: dataSource.sharesFound, activeMiners: dataSource.activeMiners, pendingBalance: dataSource.pendingBalance)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleAddressMinerStats(viewModel: AddressMiningStatsViewModel) {
        dataSource.pendingBalance = viewModel.stats.pendingBalance
        
        lowPowerVC?.configure(hashRate: dataSource.hashRate, totalHashes: dataSource.totalHashes, sharesFound: dataSource.sharesFound, activeMiners: dataSource.activeMiners, pendingBalance: dataSource.pendingBalance)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleUpdate(viewModel: MineViewModel) {
        dataSource.settings = viewModel.settings
        
        tableView.contentInset = dataSource.settings != nil ? .zero : UIEdgeInsets(top: self.view.layoutMargins.top + 54.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.isScrollEnabled = dataSource.settings != nil

        if let settings = viewModel.settings {
            (interactor as? MineInteractor)?.numberOfThreads = Int(settings.threads)
            
            interactor.fetchStats(settings: settings)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func handleJobSubmitted() {
        log.info("Total shares found: \(dataSource.sharesFound)")
    }
    
    // MARK: - Actions
    
    @objc func menuTapped() {
        router.showHome()
    }
    
    @objc func showStats() {
        if let settings = self.dataSource.settings {
            router.showStats(settings: settings)
        }
    }
    
    @objc func lowPowerTapped() {
        self.lowPowerVC = MineLowPowerVC()
        
        if let lowPowerVC = lowPowerVC {
            self.present(NavigationController(rootViewController: lowPowerVC), animated: true, completion: {
                self.videoBackgroundQueue.pause()
            })
        }
    }
    
    func resetIdleTimer() {
        idleTimer?.invalidate()
        
        idleTimer = Timer.scheduledTimer(withTimeInterval: 300.0, repeats: false, block: { timer in
            guard self.miningStatus == .mining else { return }
            
            self.lowPowerTapped()
        })
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let _ = dataSource.settings else {
            return UITableViewAutomaticDimension
        }
        
        if indexPath.section == 0 {
            return view.bounds.size.height - (45.0 * CGFloat(tableView.numberOfSections - 1)) - self.view.layoutMargins.top - self.view.layoutMargins.bottom - 20.0
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let _ = dataSource.settings else {
            guard indexPath.section == 2 else { return }
            
            if indexPath.row == 0 {
                router.showAddWallet()
            } else if indexPath.row == 1 {
                router.showImportWalletWithKey()
            } else if indexPath.row == 2 {
                router.showImportWalletWithQRCode()
            }
            
            return
        }

        guard indexPath.section != 0 else { return }
        
        stopMining()
        
        if indexPath.section == 1 {
            guard let threads = dataSource.settings?.threads else { return }
            router.showThreadsSettings(threads: threads)
        } else if indexPath.section == 2 {
            guard let pool = dataSource.settings?.pool else { return }
            
            router.showPoolSettings(pool: pool)
        } else if indexPath.section == 3 {
            guard let wallet = dataSource.settings?.wallet else { return }
            router.showWalletSettings(selectedWallet: wallet)
        }
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        videoBackgroundLayer.frame = CGRect(x: self.view.bounds.origin.x - self.view.safeAreaInsets.left,
                                            y: self.view.bounds.origin.y,
                                            width: self.view.bounds.size.width + self.view.safeAreaInsets.left + self.view.safeAreaInsets.right,
                                            height: self.view.bounds.size.height + self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom)
    }
    
}
