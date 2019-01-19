//
//  ViewController.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BLOC.MONEY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configure() {
        let backgroundImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = R.image.defaultBg()
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = (navigationController as? UIGestureRecognizerDelegate)
    }
    
}
