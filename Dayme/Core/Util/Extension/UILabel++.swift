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
    
    @discardableResult
    func numberOfLines(_ length: Int) -> Self {
        self.numberOfLines = length
        return self
    }
    
    @discardableResult
    func lineHeight(_ height: CGFloat) -> Self {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = height
        paragraphStyle.minimumLineHeight = height
        paragraphStyle.alignment = textAlignment
        
        var attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (height - font.lineHeight) / 2
        ]
        
        if let font {
            attributes[.font] = font
        }
        
        if let textColor {
            attributes[.foregroundColor] = textColor
        }
        
        attributedText = NSAttributedString(
            string: text.orEmpty,
            attributes: attributes
        )
        
        return self
    }
    
    @discardableResult
    func lineHeight(multiple: CGFloat) -> Self {
        lineHeight(font.lineHeight * multiple)
    }
    
    @discardableResult
    func typo(_ typo: Typo) -> Self {
        font(typo.font)
            .lineHeight(multiple: typo.lineHeight)
    }
    
}
