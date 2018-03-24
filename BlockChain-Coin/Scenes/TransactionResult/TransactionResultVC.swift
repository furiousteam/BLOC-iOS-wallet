//  
//  TransactionResultVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 23/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class TransactionResultVC: ViewController {
    
    enum Result {
        case success
        case error(error: String)
        
        var image: UIImage? {
            switch self {
            case .success:
                return R.image.transaction_success()
            case .error:
                return R.image.transaction_error()
            }
        }
        
        var title: String {
            switch self {
            case .success:
                return R.string.localizable.send_success_title()
            case .error:
                return R.string.localizable.send_error_title()
            }
        }
        
        var subtitle: String {
            switch self {
            case .success:
                return R.string.localizable.send_success_subtitle()
            case .error(let error):
                return error
            }
        }
    }
    
    let router: TransactionResultRoutingLogic
    
    let formView = ScrollableStackView()
    let formFields = TransactionResultFormViews()

    let result: Result
    
    let wavesBgImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.wavesBg())
        imageView.tintColor = UIColor(hex: 0x00ffff)
        imageView.alpha = 0.5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - View lifecycle
    
    init(result: Result) {
        let router = TransactionResultRouter()
        
        self.router = router
        
        self.result = result
        
        super.init(nibName: nil, bundle: nil)
        
        router.viewController = self
    }
    
    init(router: TransactionResultRoutingLogic, result: Result) {
        self.router = router
        
        self.result = result
        
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
        
        view.addSubview(wavesBgImageView)
        
        // Form
        
        formView.stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 40.0)
        formView.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        wavesBgImageView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        
        formFields.imageView.image = result.image
        formFields.titleLabel.text = result.title.localizedUppercase
        formFields.subtitleLabel.text = result.subtitle
        
        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_send_title(), subtitle: R.string.localizable.home_menu_send_subtitle())
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    // MARK: - Actions
    
    @objc func backTapped() {
        router.goBack(result: result)
    }

}
