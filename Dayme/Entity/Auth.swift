//
//  Auth.swift
//  Dayme
//
//  Created by 정동천 on 11/5/24.
//

import Foundation
import UIKit.UIImage

enum OAuthProvider: String {
    case google, kakao, apple
    
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
    
    var code: String { rawValue.uppercased() }
}

struct OAuthToken {
    let accessToken: String
    let refreshToken: String
}
