//
//  TextField.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit

final class BorderedTF: UITextField {
    
    var contentInsets: UIEdgeInsets = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        layer.borderColor = .uiColor(.colorGrey20)
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
    
}
