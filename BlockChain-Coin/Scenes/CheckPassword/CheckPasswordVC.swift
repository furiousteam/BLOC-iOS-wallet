//  
//  CheckPasswordVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 22/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CheckPasswordVCDelegate: class {
    func didEnterPassword(checkPasswordVC: CheckPasswordVC, string: String)
}

class CheckPasswordVC: ViewController {
    
    let formView = ScrollableStackView()
    let formFields = CheckPasswordFormViews()
    
    let wallet: WalletModel
    let titleView: TitleView
    
    let disposeBag = DisposeBag()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.defaultBg()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    weak var delegate: CheckPasswordVCDelegate?
    
    // MARK: - View lifecycle
    
    init(wallet: WalletModel, titleView: TitleView, delegate: CheckPasswordVCDelegate?) {
        self.wallet = wallet
        self.delegate = delegate
        self.titleView = titleView
        
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
        view.backgroundColor = .black
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })

        view.addSubview(formView)
        
        formView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // Form
        
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        formFields.passwordField.didTapReturn = nextTapped
        
        formFields.nextButton.isEnabled = false
        
        formFields.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        formFields.passwordField.rx_text.subscribe(onNext: { text in
            guard let p = self.wallet.password, let text = text else {
                self.formFields.nextButton.isEnabled = false
                return
            }
            
            self.formFields.nextButton.isEnabled = (text == p)
        }).disposed(by: disposeBag)
        
        // Navigation Bar
                
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func nextTapped() {
        do {
            guard let password = wallet.password, let userPassword = try formFields.passwordField.rx_text.value(), password == userPassword else { return }
            
            delegate?.didEnterPassword(checkPasswordVC: self, string: userPassword)
        } catch {
            
        }
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
