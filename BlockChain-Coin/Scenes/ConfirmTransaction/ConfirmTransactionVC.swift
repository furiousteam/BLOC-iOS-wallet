//  
//  ConfirmTransactionVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

protocol ConfirmTransactionDisplayLogic: class {
    func handleUpdate(viewModel: ConfirmTransactionViewModel)
}

class ConfirmTransactionVC: ViewController, ConfirmTransactionDisplayLogic {
    
    let router: ConfirmTransactionRoutingLogic
    let interactor: ConfirmTransactionBusinessLogic
    
    let formView = ScrollableStackView()
    let formFields = ConfirmTransactionFormViews()

    let form: NewTransactionForm
    
    let wavesBgImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.wavesBg())
        imageView.tintColor = UIColor(hex: 0x00ffff)
        imageView.alpha = 0.5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - View lifecycle
    
    init(form: NewTransactionForm) {
        let interactor = ConfirmTransactionInteractor()
        let presenter = ConfirmTransactionPresenter()
        let router = ConfirmTransactionRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.form = form
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: ConfirmTransactionRoutingLogic, interactor: ConfirmTransactionBusinessLogic, form: NewTransactionForm) {
        self.router = router
        self.interactor = interactor
        
        self.form = form
        
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
        
        view.insertSubview(wavesBgImageView, belowSubview: formView.scrollView)

        // Form
        
        formView.stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        formView.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        formFields.confirmButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        
        wavesBgImageView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(formFields.confirmButton.snp.bottom).offset(70.0)
        })
        
        formFields.amountLabel.text = form.amount?.blocCurrency(includeCurrency: false) ?? "0.0"
        formFields.addressLabel.text = form.address
        formFields.feeLabel.text = R.string.localizable.send_confirm_fee((Constants.minimumFee / Constants.walletCurrencyDivider).blocCurrency())

        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_send_title(), subtitle: R.string.localizable.home_menu_send_subtitle())
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }

    @objc func didTapSend() {
        // TODO: Slide to confirm
        
        interactor.transfer(request: ConfirmTransactionRequest(form: form))
    }
    
    @objc func backTapped() {
        router.goBack()
    }
    
    // MARK: UI Update
    
    func handleUpdate(viewModel: ConfirmTransactionViewModel) {
        // TODO: Loading state
        // TODO: Error state
        
        switch viewModel.state {
        case .loaded:
            router.showResult(error: nil)
        case.loading:
            log.info("Loading")
        case .error(let errorText):
            router.showResult(error: errorText)
        }
    }
}
