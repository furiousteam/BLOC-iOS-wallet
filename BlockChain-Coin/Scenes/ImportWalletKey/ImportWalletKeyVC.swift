//  
//  ImportWalletKeyVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ImportWalletKeyDisplayLogic: class {
    func handleUpdate(viewModel: ImportWalletKeyViewModel)
}

class ImportWalletKeyVC: ViewController, ImportWalletKeyDisplayLogic {
    
    let formView = ScrollableStackView()
    let formFields = ImportWalletKeyFormViews()

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
        view.backgroundColor = .clear
        
        view.addSubview(formView)
        
        formView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // Form
        
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        formFields.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_wallet_title(), subtitle: R.string.localizable.home_menu_wallet_subtitle())
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }

    // MARK: Actions
    
    @objc func backTapped() {
        router.goBack()
    }
    
    @objc func nextTapped() {
        log.info("Restoring wallet from key...")
        
        let form = ImportWalletKeyForm(keysString: formFields.textView.text)
        
        interactor.validateForm(request: ImportWalletKeyRequest(form: form))
    }
    
    // MARK: UI Update
    
    func handleUpdate(viewModel: ImportWalletKeyViewModel) {
        // TODO: Loading state
        // TODO: Error state
        
        log.info("State update: \(viewModel.state)")
        
        switch viewModel.state {
        case .validForm:
            let form = ImportWalletKeyForm(keysString: formFields.textView.text)
            
            interactor.importWallet(request: ImportWalletKeyRequest(form: form))
        case .completed(let wallet):
            self.view.endEditing(true)
            router.showWalletSetPassword(wallet: wallet)
        default:
            break
        }
    }
}
