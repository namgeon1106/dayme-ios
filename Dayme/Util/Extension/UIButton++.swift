//
//  UIButton++.swift
//  Dayme
//
//  Created by 정동천 on 11/2/24.
//

import UIKit

extension UIButton {
    
    @discardableResult
    func onAction(_ handler: @escaping() -> Void) -> Self {
        onAction(for: .touchUpInside, handler)
    }
    
    @discardableResult
    func onAction(_ handler: @escaping() async -> Void) -> Self {
        onAction(for: .touchUpInside, handler)
    }
    
    @discardableResult
    func image(_ image: UIImage?, for control: UIControl.State) -> Self {
        setImage(image, for: control)
        return self
    }
    
}
