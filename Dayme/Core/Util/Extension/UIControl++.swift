//
//  UIControl++.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit

extension UIControl {
    
    @discardableResult
    func onAction(for controlEvent: UIControl.Event,
                  _ handler: @escaping() -> Void) -> Self {
        let action = UIAction { _ in handler() }
        addAction(action, for: controlEvent)
        return self
    }
    
    @discardableResult
    func onAction(for controlEvent: UIControl.Event,
                  _ handler: @escaping() async -> Void) -> Self {
        let action = UIAction { _ in Task { await handler() } }
        addAction(action, for: controlEvent)
        return self
    }
    
}
