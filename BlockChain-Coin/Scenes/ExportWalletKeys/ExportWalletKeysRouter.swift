//  
//  ExportWalletKeysRouter.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import SnapKit

protocol ExportWalletKeysRoutingLogic {
    func showPrintPreview(keys: String)
    func goToWallet(wallet: WalletModel)
}

class ExportWalletKeysRouter: Router, ExportWalletKeysRoutingLogic {
    weak var viewController: UIViewController?
    
    var printView: PrintableWalletKeysView?
    
    func showPrintPreview(keys: String) {
        self.printView = PrintableWalletKeysView(keys: keys)
        
        let pdfData = NSMutableData()
        
        if let printView = printView {
            viewController?.view.addSubview(printView)
            
            printView.snp.makeConstraints({
                $0.leading.trailing.top.equalToSuperview()
            })
            
            viewController?.view.layoutSubviews()
            
            UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0, y: 0, width: printView.bounds.width, height: printView.bounds.height), nil)
            
            if let context = UIGraphicsGetCurrentContext() {
                UIGraphicsBeginPDFPage()
                printView.layer.render(in: context)
                UIGraphicsEndPDFContext()
            }
            
            printView.removeFromSuperview()
        }
        
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.orientation = .portrait
        printInfo.outputType = .grayscale
        
        let printInteractor = UIPrintInteractionController.shared
        printInteractor.printingItem = pdfData
        printInteractor.printInfo = printInfo
        
        printInteractor.present(animated: true) { (printController, completed, error) in
            self.printView = nil
        }
    }
    
    func goToWallet(wallet: WalletModel) {
        // TODO: Show wallet
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}

