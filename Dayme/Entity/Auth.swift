//
//  Auth.swift
//  Dayme
//
//  Created by 정동천 on 11/5/24.
//

import Foundation
import UIKit.UIImage

enum OAuthProvider {
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
        case .google: "구글 계정으로 로그인"
        case .kakao: "카카오톡으로 로그인"
        case .apple: "애플 계정으로 로그인"
        }
    }
}

struct OAuthToken {
    let accessToken: String
    let refreshToken: String
    let expiration: Date
}
