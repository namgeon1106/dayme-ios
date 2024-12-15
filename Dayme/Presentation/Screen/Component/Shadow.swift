//
//  Shadow.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import UIKit

struct Shadow {
    let color: UIColor
    let offset: CGSize
    let blur: CGFloat
}

extension Shadow {
    static let card = Shadow(
        color: .colorDarkA10,
        offset: .zero,
        blur: 8
    )
    
    static let button = Shadow(
        color: .colorDarkA25,
        offset: .zero,
        blur: 4
    )
    
    static let modal = Shadow(
        color: .white.withAlphaComponent(0.07),
        offset: CGSize(width: 0, height: 1),
        blur: 2
    )
}

extension UIView {
    @discardableResult
    func addShadow(_ shadow: Shadow = .card) -> Self {
        layer.masksToBounds = false
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOffset = shadow.offset
        layer.shadowRadius = shadow.blur / 2
        layer.shadowOpacity = 1
        return self
    }
}
