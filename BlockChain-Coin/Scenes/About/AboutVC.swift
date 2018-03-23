//  
//  AboutVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol AboutDisplayLogic: class {
    func handleUpdate(viewModel: AboutViewModel)
}

class AboutVC: ViewController, AboutDisplayLogic {
    
    let formView = ScrollableStackView()
    let formFields = AboutFormViews()

    let router: AboutRoutingLogic
    let interactor: AboutBusinessLogic
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.aboutUsBg())
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
        
        commonInit()
    }
    
    init(router: AboutRoutingLogic, interactor: AboutBusinessLogic) {
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    func commonInit() {
        tabBarItem = UITabBarItem(title: nil, image: R.image.tabBarAbout(), selectedImage: nil)
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
        view.backgroundColor = .clear
        
        view.addSubview(backgroundImageView)

        view.addSubview(formView)
        
        formView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // Form
        
        formView.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        formFields.logo.snp.makeConstraints({
            $0.height.equalTo(160.0)
        })
        
        formFields.websiteButton.addTarget(self, action: #selector(websiteTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions

    @objc func websiteTapped() {
        UIApplication.shared.open(URL(string: "http://www.blockchain-coin.net")!, options: [:], completionHandler: nil)
    }
    
    // MARK: - UI Update
    
    func handleUpdate(viewModel: AboutViewModel) {
        
    }
}
