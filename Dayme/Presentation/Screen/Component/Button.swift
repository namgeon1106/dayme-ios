//
//  Button.swift
//  Dayme
//
//  Created by 정동천 on 11/1/24.
//

import UIKit

// MARK: - BoarderdButton

final class BoarderdButton: UIButton {
    
    init(_ title: String, color: UIColor) {
        super.init(frame: .zero)
        
        var attrString = AttributedString(title)
        attrString.font = .pretendard(.bold, 18)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .clear
        config.background.cornerRadius = 12
        config.background.strokeWidth = 1
        config.background.strokeColor = color
        config.baseForegroundColor = color
        config.attributedTitle = attrString
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - FilledButton

final class FilledButton: UIButton {
    
    init(_ title: String) {
        super.init(frame: .zero)
        
        var attrString = AttributedString(title)
        attrString.font = .pretendard(.bold, 18)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .colorMain1
        config.background.cornerRadius = 12
        config.baseForegroundColor = .white
        config.attributedTitle = attrString
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - FilledSecondaryButton

final class FilledSecondaryButton: UIButton {
    
    init(_ title: String) {
        super.init(frame: .zero)
        
        var attrString = AttributedString(title)
        attrString.font = .pretendard(.semiBold, 12)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .colorMain3
        config.background.cornerRadius = 5
        config.baseForegroundColor = .colorMain1
        config.attributedTitle = attrString
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - SocialLoginButton

final class SocialLoginButton: UIButton {
    
    private(set) var provider: OAuthProvider!
    
    init(_ provider: OAuthProvider) {
        self.provider = provider
        super.init(frame: .zero)
        
        var attrString = AttributedString(provider.title)
        attrString.font = .pretendard(.bold, 16)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = provider.backgroundColor
        config.baseForegroundColor = provider.foregroundColor
        config.background.cornerRadius = 12
        config.attributedTitle = attrString
        config.image = provider.image
        config.imagePadding = 4
        
        if provider.hasBorder {
            config.background.strokeWidth = 1
            config.background.strokeColor = .colorGrey20
        }
        
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
