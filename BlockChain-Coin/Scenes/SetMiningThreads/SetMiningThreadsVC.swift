//  
//  SetMiningThreadsVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 29/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol SetMiningThreadsDisplayLogic: class {
    func handleUpdate(viewModel: SetMiningThreadsViewModel)
}

class SetMiningThreadsVC: ViewController, SetMiningThreadsDisplayLogic {
    
    let formView = ScrollableStackView()
    let formFields = SetMiningThreadsViews()

    let router: SetMiningThreadsRoutingLogic
    let interactor: SetMiningThreadsBusinessLogic
    
    let threads: UInt
    
    // MARK: - View lifecycle
    
    init(threads: UInt) {
        let interactor = SetMiningThreadsInteractor()
        let presenter = SetMiningThreadsPresenter()
        let router = SetMiningThreadsRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.threads = threads
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: SetMiningThreadsRoutingLogic, interactor: SetMiningThreadsBusinessLogic, threads: UInt) {
        self.router = router
        self.interactor = interactor
        
        self.threads = threads
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Configuration
    
    override func configure() {
        super.configure()
        
        view.backgroundColor = .clear
        
        view.addSubview(formView)
        
        formView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
                
        // Form
        
        formView.stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        formView.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
                
        view.layoutSubviews()
        
        let numberOfThreads = ProcessInfo.processInfo.activeProcessorCount
        formFields.sliderView.sliderView.value = (Float(threads) / Float(numberOfThreads))
        formFields.sliderView.sliderView.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: .valueChanged)
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_mining_title(), subtitle: R.string.localizable.home_menu_mining_subtitle())
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    // MARK: Actions
    
    @objc func sliderValueChanged(slider: UISlider) {
        let numberOfThreads = Float(ProcessInfo.processInfo.activeProcessorCount)

        let value = UInt(max(1, ceil(numberOfThreads * slider.value)))
        
        log.info("New thread count: \(value)")
        
        interactor.saveSelectedThreads(threads: value)
    }
    
    @objc func backTapped() {
        router.goBack()
    }

    // MARK: UI Update
    
    func handleUpdate(viewModel: SetMiningThreadsViewModel) {
        
    }
}
