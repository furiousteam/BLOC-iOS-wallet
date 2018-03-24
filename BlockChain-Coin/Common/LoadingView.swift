//
//  LoadingView.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 24/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class LoadingView: View {
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.hidesWhenStopped = false
        return indicator
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 64.0)
    }
    
    override func commonInit() {
        super.commonInit()
        
        loadingIndicator.startAnimating()
        addSubview(loadingIndicator)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        loadingIndicator.snp.makeConstraints({
            $0.centerX.centerY.equalToSuperview()
        })
    }
    
    func startAnimating() {
        loadingIndicator.startAnimating()
    }
    
    func stopAnimating() {
        loadingIndicator.stopAnimating()
    }
    
}

