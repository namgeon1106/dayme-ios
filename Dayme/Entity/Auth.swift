//
//  Auth.swift
//  Dayme
//
//  Created by 정동천 on 11/5/24.
//

import Foundation
import class UIKit.UIImage
import class UIKit.UIColor

struct OAuthToken {
    let accessToken: String
    let refreshToken: String
}

enum OAuthProvider: String {
    case google, kakao, apple
    
    var code: String {
        rawValue.uppercased()
    }
    
    var image: UIImage {
        switch self {
        case .google: .icSocialGoogle
        case .kakao: .icSocialKakao
        case .apple: .icSocialApple
        }
    }
    
    var title: String {
        switch self {
        case .google: L10n.Login.googleLogin
        case .kakao: L10n.Login.kakaoLogin
        case .apple: L10n.Login.appleLogin
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .google: .black
        case .kakao: .black
        case .apple: .white
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .google: .white
        case .kakao: .colorSocialKakao
        case .apple: .black
        }
    }
    
    var hasBorder: Bool {
        self == .google
    }
    
}
