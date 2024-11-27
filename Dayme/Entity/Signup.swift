//
//  Signup.swift
//  Dayme
//
//  Created by 정동천 on 11/27/24.
//

import Foundation

struct OAuthSignupInfo {
    let provider: OAuthProvider
    let token: String
    let nickname: String
    
    init(provider: OAuthProvider, token: String, nickname: String = "") {
        self.provider = provider
        self.token = token
        self.nickname = nickname
    }
    
    func copyWith(nickname: String = "") -> OAuthSignupInfo {
        return OAuthSignupInfo(provider: provider, token: token, nickname: nickname)
    }
}
