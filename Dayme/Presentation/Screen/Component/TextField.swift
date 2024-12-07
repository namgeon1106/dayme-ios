//
//  TextField.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit

final class BorderedTF: UITextField {
    
    var contentInsets: UIEdgeInsets = .zero
    
    private lazy var keyboardToolbar = UIToolbar().then {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let config = UIImage.SymbolConfiguration(pointSize: 16)
        let image = UIImage(systemName: "keyboard.chevron.compact.down", withConfiguration: config)
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(barButtonDidTap))
        $0.items = [flexibleSpace, button]
        $0.sizeToFit()
        $0.tintColor = .colorMain1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        layer.borderColor = .uiColor(.colorGrey20)
        inputAccessoryView = keyboardToolbar
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInsets)
    }
    
    override func becomeFirstResponder() -> Bool {
        layer.borderWidth = 2
        layer.borderColor = .uiColor(.colorMain1)
        
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        layer.borderWidth = 1
        layer.borderColor = .uiColor(.colorGrey20)
        
        return super.resignFirstResponder()
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        super.clearButtonRect(forBounds: bounds)
            .offsetBy(dx: -contentInsets.right, dy: 0)
    }
    
    @objc private func barButtonDidTap() {
        _ = resignFirstResponder()
    }
    
}
