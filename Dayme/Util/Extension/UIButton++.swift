//
//  UIButton++.swift
//  Dayme
//
//  Created by 정동천 on 11/2/24.
//

import UIKit

extension UIButton {
    
    @discardableResult
    func onAction(for controlEvent: UIControl.Event = .touchUpInside,
                  _ handler: @escaping() -> Void) -> Self {
        addAction(UIAction { _ in handler() }, for: controlEvent)
        return self
    }
    
    @discardableResult
    func onAction(for controlEvent: UIControl.Event = .touchUpInside,
                  _ handler: @escaping() async -> Void) -> Self {
        addAction(UIAction { _ in Task { await handler() } }, for: controlEvent)
        return self
    }
    
}
