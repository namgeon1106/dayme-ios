//
//  UITextField++.swift
//  Dayme
//
//  Created by 정동천 on 11/22/24.
//

import UIKit

extension UITextField {
    
    @discardableResult
    func onEditingChanged(for controlEvent: UIControl.Event = .editingChanged,
                  _ handler: @escaping() -> Void) -> Self {
        addAction(UIAction { _ in handler() }, for: controlEvent)
        return self
    }
    
    @discardableResult
    func onEditingChanged(for controlEvent: UIControl.Event = .touchUpInside,
                  _ handler: @escaping() async -> Void) -> Self {
        addAction(UIAction { _ in Task { await handler() } }, for: controlEvent)
        return self
    }
    
}
