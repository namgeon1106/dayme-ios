//
//  Button.swift
//  Dayme
//
//  Created by 정동천 on 11/1/24.
//

import UIKit

final class FilledButton: UIButton {
    
    init(_ title: String) {
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
    
    private(set) var provider: OAuthProvider!
    
    init(_ provider: OAuthProvider) {
        self.provider = provider
        super.init(frame: .zero)
        
        var attrString = AttributedString(provider.title)
        attrString.font = .systemFont(ofSize: 16, weight: .bold)
        
        var config = UIButton.Configuration.plain()
        config.background.strokeWidth = 1
        config.background.strokeColor = .colorBorder
        config.background.cornerRadius = 12
        config.baseForegroundColor = .colorContentPrimary
        config.attributedTitle = attrString
        config.image = provider.image
        config.imagePadding = 4
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
