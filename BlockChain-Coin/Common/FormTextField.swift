//
//  FormTextField.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FormTextField: View, UITextFieldDelegate {
    
    var didBecomeFirstResponder: () -> () = { }
    var didTapReturn: () -> () = { }
    
    fileprivate let disposeBag = DisposeBag()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 44.0)
    }
    
    var placeholder: String? {
        didSet {
            let placeholderStyle: [NSAttributedStringKey: Any] = [ .font: UIFont.regular(size: 12.5),
                                                                   .foregroundColor: UIColor.white.withAlphaComponent(0.5) ]
            let attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: placeholderStyle)
            textField.attributedPlaceholder = attributedPlaceholder
        }
    }
    
    var rx_text = BehaviorSubject<String?>(value: nil)
    
    var text: String? {
        didSet {
            textField.text = text
            rx_text.onNext(text)
        }
    }
        
    let textField: TextField = {
        let textField = TextField()
        textField.borderStyle = .none
        textField.font = .regular(size: 12.5)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.backgroundColor = UIColor(hex: 0x000a2b)
        textField.layer.cornerRadius = 4.0
        textField.layer.masksToBounds = true
        return textField
    }()
        
    override func commonInit() {
        super.commonInit()
        
        textField.delegate = self
        
        addSubview(textField)
        
        textField.rx.text.bind(to: rx_text).disposed(by: disposeBag)
    }
    
    override func createConstraints() {
        super.createConstraints()
        
        textField.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.layer.rasterizationScale = UIScreen.main.scale
        textField.layer.shouldRasterize = true
    }
    
    // MARK: - Actions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapReturn()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBecomeFirstResponder()
    }
    
}
