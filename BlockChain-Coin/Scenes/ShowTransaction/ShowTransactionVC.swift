//  
//  ShowTransactionVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 25/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

protocol ShowTransactionDisplayLogic: class {
    func handleUpdate(viewModel: ShowTransactionViewModel)
}

class ShowTransactionVC: ViewController, ShowTransactionDisplayLogic {
    
    let router: ShowTransactionRoutingLogic
    let interactor: ShowTransactionBusinessLogic
    
    let transaction: ListTransactionItemViewModel
    
    let formView = ScrollableStackView()
    let formFields = ShowTransactionFormViews()
    
    // MARK: - View lifecycle
    
    init(transaction: ListTransactionItemViewModel) {
        let interactor = ShowTransactionInteractor()
        let presenter = ShowTransactionPresenter()
        let router = ShowTransactionRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.transaction = transaction
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: ShowTransactionRoutingLogic, interactor: ShowTransactionBusinessLogic, transaction: ListTransactionItemViewModel) {
        self.router = router
        self.interactor = interactor
        
        self.transaction = transaction
        
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
        
        formView.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        formView.stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)

        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        formFields.titleView.configure(transaction: transaction)
        
        formFields.amountView.configure(content: formFields.attributedString(forAmount: transaction.transaction.amount))
        
        formFields.dateView.configure(content: formFields.attributedString(titleAndContent: R.string.localizable.transaction_details_date(transaction.transaction.createdAt.fullDate()), content: transaction.transaction.createdAt.fullDate()))
        
        if let destinationAddress = transaction.transaction.transfers.first(where: { $0.address != transaction.sourceAddress })?.address {
            let destionationTitle = transaction.transaction.transactionType == .sent ? R.string.localizable.transaction_details_sent_to() : R.string.localizable.transaction_details_from()
            
            formFields.destinationView.configure(content: formFields.attributedString(titleAndContent: "\(destionationTitle)\n\(destinationAddress)", content: destinationAddress))
        } else {
            formFields.destinationView.isHidden = true
        }
        
        
        formFields.hashView.configure(content: formFields.attributedString(titleAndContent: "\(R.string.localizable.transaction_details_hash())\n\(transaction.transaction.hash)", content: transaction.transaction.hash))

        let blockHeightString = formFields.attributedString(titleAndContent: R.string.localizable.transaction_details_block_height("\(transaction.transaction.blockIndex)"), content: "\(transaction.transaction.blockIndex)")
        let transfersString = formFields.attributedString(titleAndContent: R.string.localizable.transaction_details_transfers("\(transaction.transaction.transfers.count)"), content: "\(transaction.transaction.transfers.count)")

        formFields.heightAndTransferView.configure(leftContent: blockHeightString, rightContent: transfersString)
        
        let feeString = formFields.attributedString(titleAndContent: R.string.localizable.transaction_details_fee("\(transaction.transaction.fee.blocCurrency())"), content: "\(transaction.transaction.fee.blocCurrency())")
        let paymentIdString = formFields.attributedString(titleAndContent: R.string.localizable.transaction_details_payment_id("\(transaction.transaction.paymentId)"), content: "\(transaction.transaction.paymentId)")

        formFields.feeAndPaymentIDView.configure(leftContent: feeString, rightContent: paymentIdString)

        formFields.explorerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(explorerTapped)))
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_transactions_title(), subtitle: R.string.localizable.home_menu_transactions_subtitle())
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    

    // MARK: - Actions
    
    @objc func goBack() {
        router.goBack()
    }
    
    @objc func explorerTapped() {
        // TODO: Block hash
        router.showExplorer(blockHash: "hash", transactionHash: transaction.transaction.hash)
    }
    
    // MARK: - UI Update
    
    func handleUpdate(viewModel: ShowTransactionViewModel) {
        
    }
}
