//
//  UILabel++.swift
//  Dayme
//
//  Created by 정동천 on 11/2/24.
//

import UIKit

extension UILabel {
    
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    @discardableResult
    func text(_ text: String) -> Self {
        self.text = text
        return self
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
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
}
