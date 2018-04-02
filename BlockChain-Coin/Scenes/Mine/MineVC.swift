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
    
    var timer: Timer?
    var globalTap: UITapGestureRecognizer?
    
    enum MiningStatus {
        case notMining
        case mining
    }
    
    var miningStatus: MiningStatus = .notMining {
        didSet {
            switch miningStatus {
            case .mining:
                self.videoBackgroundQueue.play()
                
                self.outroImageView.stopAnimatingGif()
                self.outroImageView.isHidden = true

                UIApplication.shared.isIdleTimerDisabled = true
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                resetTimer()
            case .notMining:
                timer?.invalidate()

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
        
        resetTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(R.image.navBarBg(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
        
        timer?.invalidate()
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

        // TableView
        
        MineSettingsCell.registerWith(tableView)
        MiningBootCell.registerWith(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        dataSource.didChangeSwitch = { isOn in
            guard let settings = self.dataSource.settings else { return }
            
            switch self.miningStatus {
            case .mining:
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
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_mining_title(), subtitle: R.string.localizable.home_menu_mining_subtitle())
        self.navigationItem.titleView = titleView
        
        let menuButton = UIBarButtonItem(image: R.image.menuIcon(), style: .plain, target: self, action: #selector(menuTapped))
        self.navigationItem.setLeftBarButton(menuButton, animated: false)
        
        let lowPowerButton = UIBarButtonItem(image: R.image.lowPower(), style: .plain, target: self, action: #selector(lowPowerTapped))
        self.navigationItem.setRightBarButton(lowPowerButton, animated: false)
    }
    
    func stopMining() {
        if miningStatus == .mining {
            self.interactor.disconnect()
            
            NotificationCenter.default.post(name: Notification.Name("miningSwitchChangeState"), object: nil)
        }
    }
    
    func gifDidLoop(sender: UIImageView) {
        self.outroImageView.isHidden = true
        
        NotificationCenter.default.post(name: Notification.Name("miningSwitchEnable"), object: true)
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        switch miningStatus {
        case .mining:
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
        
        lowPowerVC?.configure(hashRate: dataSource.hashRate, totalHashes: dataSource.totalHashes, sharesFound: dataSource.sharesFound, activeMiners: dataSource.activeMiners, pendingBalance: dataSource.pendingBalance)
        
        tableView.reloadData()
    }
    
    func handleUpdate(viewModel: MineViewModel) {
        dataSource.settings = viewModel.settings
        
        (interactor as? MineInteractor)?.numberOfThreads = Int(viewModel.settings.threads)
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc func menuTapped() {
        router.showHome()
    }
    
    @objc func showStats() {
        router.showStats()
    }
    
    @objc func lowPowerTapped() {
        self.lowPowerVC = MineLowPowerVC()
        
        if let lowPowerVC = lowPowerVC {
            self.present(NavigationController(rootViewController: lowPowerVC), animated: true, completion: {
                self.videoBackgroundQueue.pause()
            })
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 120.0, repeats: false, block: { timer in
            guard self.miningStatus == .mining else { return }
            
            self.lowPowerTapped()
        })
    }
    
    // MARK: - UITableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return view.bounds.size.height - (90.0 * CGFloat(tableView.numberOfSections - 1))
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
