//  
//  AddPoolVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 30/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddPoolDisplayLogic: class {
    func handleUpdate(viewModel: AddPoolViewModel)
}

class AddPoolVC: ViewController, AddPoolDisplayLogic {
    
    let router: AddPoolRoutingLogic
    let interactor: AddPoolBusinessLogic
    
    let formView = ScrollableStackView()
    let formFields = AddPoolViews()
    let toolbar = FormToolbar()
    
    let disposeBag = DisposeBag()

    // MARK: - View lifecycle
    
    init() {
        let interactor = AddPoolInteractor()
        let presenter = AddPoolPresenter()
        let router = AddPoolRouter()
        
        self.router = router
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: AddPoolRoutingLogic, interactor: AddPoolBusinessLogic) {
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
    
    override func configure() {
        super.configure()
        
        view.backgroundColor = .clear
        
        view.addSubview(formView)
        
        formView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // Form
        
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        [ formFields.urlField, formFields.portField ].forEach { field in
            field.textField.inputAccessoryView = toolbar
            field.didBecomeFirstResponder = toolbar.updateArrows
            field.didTapReturn = toolbar.nextTapped
        }
        
        formFields.portField.didTapReturn = addPool
        
        toolbar.responders = [ formFields.urlField.textField,
                               formFields.portField.textField ]
        
        formFields.addButton.addTarget(self, action: #selector(addPool), for: .touchUpInside)
        
        Observable.combineLatest(formFields.urlField.rx_text, formFields.portField.rx_text).subscribe(onNext: { [weak self] url, port in
            let form = AddPoolForm(url: url, port: UInt(port ?? "0"))
            
            log.info(form)
            
            self?.interactor.validateForm(request: AddPoolRequest(form: form))
        }).disposed(by: disposeBag)
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_mining_title(), subtitle: R.string.localizable.home_menu_mining_subtitle())
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    // MARK: - Actions
    
    @objc func addPool() {
        let form = AddPoolForm(url: formFields.urlField.textField.text, port: UInt(formFields.portField.textField.text ?? "0"))
        
        guard form.isValid else { return }
        
        interactor.addPool(request: AddPoolRequest(form: form))
    }
    
    @objc func backTapped() {
        router.goBack()
    }

    // MARK: UI Update
    
    func handleUpdate(viewModel: AddPoolViewModel) {
        log.info("State update: \(viewModel.state)")
        
        formFields.addButton.isEnabled = viewModel.isNextButtonEnabled
        
        switch viewModel.state {
        case .completed:
            router.goBack()
            self.view.endEditing(true)
        default:
            break
        }
    }
}
