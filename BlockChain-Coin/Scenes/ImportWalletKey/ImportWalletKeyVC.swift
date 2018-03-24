//  
//  ImportWalletKeyVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ImportWalletKeyDisplayLogic: class {
    func handleUpdate(viewModel: ImportWalletKeyViewModel)
}

class ImportWalletKeyVC: ViewController, ImportWalletKeyDisplayLogic {
    
    let formView = ScrollableStackView()
    let formFields = ImportWalletKeyFormViews()

    let router: ImportWalletKeyRoutingLogic
    let interactor: ImportWalletKeyBusinessLogic
    
    let password: String
    
    var hud: MBProgressHUD?

    // MARK: - View lifecycle
    
    init(password: String) {
        let interactor = ImportWalletKeyInteractor()
        let presenter = ImportWalletKeyPresenter()
        let router = ImportWalletKeyRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.password = password
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: ImportWalletKeyRoutingLogic, interactor: ImportWalletKeyBusinessLogic, password: String) {
        self.router = router
        self.interactor = interactor
        
        self.password = password
        
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
    
    override func configure() {
        super.configure()

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
        let form = ImportWalletKeyForm(keysString: formFields.textView.text, password: password)
        
        interactor.validateForm(request: ImportWalletKeyRequest(form: form))
    }
    
    // MARK: UI Update
    
    func handleUpdate(viewModel: ImportWalletKeyViewModel) {
        self.hud?.hide(animated: true)

        log.info("State update: \(viewModel.state)")
        
        switch viewModel.state {
        case .validForm:
            let form = ImportWalletKeyForm(keysString: formFields.textView.text, password: password)
            
            interactor.importWallet(request: ImportWalletKeyRequest(form: form))
        case .completed:
            self.view.endEditing(true)
            router.goBack()
        case .loading:
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .indeterminate
            hud?.label.text = R.string.localizable.create_wallet_loading()
        case .invalidForm:
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .text
            hud?.detailsLabel.text = R.string.localizable.import_wallet_key_invalid_key()
            hud?.hide(animated: true, afterDelay: 3.0)
        case .error(let error):
            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .text
            hud?.detailsLabel.text = error
            hud?.hide(animated: true, afterDelay: 3.0)
        default:
            break
        }
    }
}
