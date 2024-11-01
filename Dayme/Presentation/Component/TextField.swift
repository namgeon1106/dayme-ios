//
//  TextField.swift
//  Dayme
//
//  Created by 정동천 on 11/1/24.
//

import UIKit

final class FilledTextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        backgroundColor = .colorBackgroundSecondary
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.colorContentSecondary,
            ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
