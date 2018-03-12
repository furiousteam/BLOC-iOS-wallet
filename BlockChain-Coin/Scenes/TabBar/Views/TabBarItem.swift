//
//  TabBarItem.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

class TabBarItem: View {
    
    static let height: CGFloat = 73.0
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.white.withAlphaComponent(0.5)
        return imageView
    }()
    
    var markerImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.tabBarMarker())
        imageView.contentMode = .center
        imageView.tintColor = .trx_blue
        return imageView
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: TabBarItem.height)
    }
    
    // MARK: - Variables
    
    static var initialAnimationDuration: Double = 0.6
    static var updateAnimationDuration: Double = 0.3
    static var dismissAnimationDuration: Double = 0.3
    
    enum NotificationAnimation {
        case initial
        case update
        case dismiss
        
        var duration: Double {
            switch self {
            case .initial:
                return TabBarItem.initialAnimationDuration
            case .update:
                return TabBarItem.updateAnimationDuration
            case .dismiss:
                return TabBarItem.dismissAnimationDuration
            }
        }
    }
    
    var notificationsCount: Int = 0 {
        didSet {
            updateNotificationsCount(oldValue: oldValue, newValue: notificationsCount)
        }
    }
    
    // MARK: - View lifecycle
    
    init(image: UIImage?, notificationsCount: Int = 0) {
        super.init()
        
        imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(imageView)
        addSubview(markerImageView)
        addSubview(bubbleView)
        
        markerImageView.alpha = 0.0
        bubbleView.alpha = 0.0
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        imageView.snp.makeConstraints({
            $0.top.equalTo(37.0)
            $0.height.equalTo(25.0)
            $0.leading.trailing.equalToSuperview()
        })
        
        markerImageView.snp.makeConstraints({
            $0.bottom.equalTo(-5.0)
            $0.width.height.equalTo(3.0)
            $0.centerX.equalToSuperview()
        })
        
        bubbleView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        })
    }
    
    // MARK: - Configuration
    
    func updateNotificationsCount(oldValue: Int, newValue: Int) {
        guard oldValue != newValue else { return }
        
        let animationType: NotificationAnimation = {
            let isInitialAnimation = (oldValue == 0)
            let isDismissAnimation = (newValue == 0)
            
            if isInitialAnimation { return .initial }
            if isDismissAnimation { return .dismiss }
            
            return .update
        }()
        
        switch animationType {
        case .initial:
            performInitialAnimation()
        case .update:
            performUpdateAnimation()
        case .dismiss:
            performDismissAnimation()
        }
    }
    
    // MARK: - Animations
    
    func performInitialAnimation() {
        bubbleView.alpha = 0.0
        bubbleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        markerImageView.alpha = 0.0
        
        bubbleView.configure(count: notificationsCount)
        
        UIView.animate(withDuration: NotificationAnimation.initial.duration) { [weak self] in
            self?.bubbleView.alpha = 1.0
            self?.markerImageView.alpha = 1.0
        }
        
        UIView.animate(withDuration: NotificationAnimation.initial.duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.0,
                       options: [ .beginFromCurrentState ],
                       animations: { [weak self] in
                        self?.bubbleView.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    func performUpdateAnimation() {
        bubbleView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        bubbleView.configure(count: notificationsCount)
        
        UIView.animate(withDuration: NotificationAnimation.update.duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.0,
                       options: [ .beginFromCurrentState ],
                       animations: { [weak self] in
                        self?.bubbleView.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    func performDismissAnimation() {
        let count = notificationsCount
        
        UIView.animate(withDuration: NotificationAnimation.dismiss.duration, animations: { [weak self] in
            self?.bubbleView.alpha = 0.0
            self?.markerImageView.alpha = 0.0
            self?.bubbleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { [weak self] _ in
            self?.bubbleView.configure(count: count)
        }
    }
}
