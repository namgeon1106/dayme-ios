//
//  Button.swift
//  Dayme
//
//  Created by 정동천 on 11/1/24.
//

import UIKit

final class FilledButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        var attrString = AttributedString(title)
        attrString.font = .systemFont(ofSize: 16, weight: .bold)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .accent
        config.background.cornerRadius = 12
        config.baseForegroundColor = .white
        config.attributedTitle = attrString
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

final class SocialLoginButton: UIButton {
    
    init(title: String, image: UIImage? = nil) {
        super.init(frame: .zero)
        
        var attrString = AttributedString(title)
        attrString.font = .systemFont(ofSize: 16, weight: .bold)
        
        var config = UIButton.Configuration.plain()
        config.background.strokeWidth = 1
        config.background.strokeColor = .border
        config.background.cornerRadius = 12
        config.baseForegroundColor = .contentPrimary
        config.attributedTitle = attrString
        config.image = image
        config.imagePadding = 4
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
