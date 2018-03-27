//  
//  ImportWalletQRCodeVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 17/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import MBProgressHUD

protocol ImportWalletQRCodeDisplayLogic: class {
    func handleUpdate(viewModel: ImportWalletQRCodeViewModel)
}

class ImportWalletQRCodeVC: ViewController, ImportWalletQRCodeDisplayLogic, QRCodeReaderViewControllerDelegate {
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    var hud: MBProgressHUD?
    
    let router: ImportWalletQRCodeRoutingLogic
    let interactor: ImportWalletQRCodeBusinessLogic
    
    let password: String
    let name: String
    var result: String? = nil
    
    // MARK: - View lifecycle
    
    init(password: String, name: String) {
        let interactor = ImportWalletQRCodeInteractor()
        let presenter = ImportWalletQRCodePresenter()
        let router = ImportWalletQRCodeRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.password = password
        self.name = name
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: ImportWalletQRCodeRoutingLogic, interactor: ImportWalletQRCodeBusinessLogic, password: String, name: String) {
        self.router = router
        self.interactor = interactor
        
        self.password = password
        self.name = name
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        readerVC.delegate = self
    }

    // MARK: - Configuration
    
    override func configure() {
        super.configure()

        view.backgroundColor = .clear
        
        addChildViewController(readerVC)
        
        view.addSubview(readerVC.view)
        
        readerVC.view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        readerVC.didMove(toParentViewController: self)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        self.result = result.value
        
        let form = ImportWalletQRCodeForm(keysString: self.result, password: password, name: name)
        
        interactor.validateForm(request: ImportWalletQRCodeRequest(form: form))
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        router.goBack()
    }

    // MARK: - UI Update
    
    func handleUpdate(viewModel: ImportWalletQRCodeViewModel) {
        self.hud?.hide(animated: true)

        log.info("State update: \(viewModel.state)")
        
        switch viewModel.state {
        case .validForm:
            let form = ImportWalletQRCodeForm(keysString: result, password: password, name: name)
            
            interactor.importWallet(request: ImportWalletQRCodeRequest(form: form))
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
        }
    }
}
