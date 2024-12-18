//
//  UIView++.swift
//  Dayme
//
//  Created by 정동천 on 11/2/24.
//

import UIKit

extension UIView {
    
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
}

extension UIView {
    
    static func animate(
        _ duration: TimeInterval,
        delay: TimeInterval = .zero,
        options: AnimationOptions = [],
        animations: @escaping() -> Void
    ) async {
        return await withCheckedContinuation { continuation in
            animate(withDuration: duration, delay: delay, options: options, animations: animations) { _ in
                continuation.resume()
            }
        }
    }
    
}
