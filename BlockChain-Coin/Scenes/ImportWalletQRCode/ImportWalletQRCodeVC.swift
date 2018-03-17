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
    
    let router: ImportWalletQRCodeRoutingLogic
    let interactor: ImportWalletQRCodeBusinessLogic
    
    let password: String
    var result: String? = nil
    
    // MARK: - View lifecycle
    
    init(password: String) {
        let interactor = ImportWalletQRCodeInteractor()
        let presenter = ImportWalletQRCodePresenter()
        let router = ImportWalletQRCodeRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.password = password
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: ImportWalletQRCodeRoutingLogic, interactor: ImportWalletQRCodeBusinessLogic, password: String) {
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
        
        readerVC.delegate = self
    }

    // MARK: - Configuration
    
    func configure() {
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
        
        let form = ImportWalletQRCodeForm(keysString: self.result, password: password)
        
        interactor.validateForm(request: ImportWalletQRCodeRequest(form: form))
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        router.goBack()
    }

    // MARK: - UI Update
    
    func handleUpdate(viewModel: ImportWalletQRCodeViewModel) {
        // TODO: Loading state
        // TODO: Error state
        
        log.info("State update: \(viewModel.state)")
        
        switch viewModel.state {
        case .validForm:
            let form = ImportWalletQRCodeForm(keysString: result, password: password)
            
            interactor.importWallet(request: ImportWalletQRCodeRequest(form: form))
        case .completed:
            self.view.endEditing(true)
            router.goBack()
        default:
            break
        }
    }
}
