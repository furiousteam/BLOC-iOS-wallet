//
//  UIScrollView+Keyboard.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(forName: Foundation.Notification.Name.UIKeyboardWillChangeFrame, object: nil, queue: nil, using: handleKeyboard(_:))
        NotificationCenter.default.addObserver(forName: Foundation.Notification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: handleKeyboard(_:))
    }
    
    func destroyKeyboardHandling() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboard(_ notification: Foundation.Notification) {
        guard let ui = notification.userInfo else { return }
        guard let screenEndFrame = (ui[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let viewEndFrame = self.convert(screenEndFrame, from: self.window)
        
        if notification.name == Foundation.Notification.Name.UIKeyboardWillHide {
            self.contentInset.bottom = 0
            self.scrollIndicatorInsets.bottom = 0
        }
        else {
            let additionalMargin: CGFloat = 20.0
            self.contentInset.bottom = viewEndFrame.height + additionalMargin
            self.scrollIndicatorInsets.bottom = viewEndFrame.height + additionalMargin
        }
    }
}
