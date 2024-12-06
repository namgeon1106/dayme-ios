//
//  UIEdgeInsets++.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import UIKit

extension UIEdgeInsets {
    
    init(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
    init(_ vertical: CGFloat, _ horizontal: CGFloat) {
        self.init(vertical, horizontal, vertical, horizontal)
    }
    
}
