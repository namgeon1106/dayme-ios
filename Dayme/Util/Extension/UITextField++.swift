//
//  UITextField++.swift
//  Dayme
//
//  Created by 정동천 on 11/22/24.
//

import UIKit

extension UITextField {
    
    convenience init(_ placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    convenience init(_ placeholder: NSAttributedString) {
        self.init(frame: .zero)
        self.attributedPlaceholder = placeholder
    }
    
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    func onAction(_ handler: @escaping() -> Void) -> Self {
        onAction(for: .editingChanged, handler)
    }
    
    @discardableResult
    func onAction(_ handler: @escaping() async -> Void) -> Self {
        onAction(for: .editingChanged, handler)
    }
    
}
