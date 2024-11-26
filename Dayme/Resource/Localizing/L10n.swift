//
//  L10n.swift
//  Dayme
//
//  Created by 정동천 on 11/10/24.
//

import Foundation

enum L10n {
    enum Login {}
}

extension L10n.Login {
    static let subTitle = String(localized: "login.subTitle", defaultValue: "더 나은 내일의 나를 위한 시작,\n지금 함께해보세요.")
    static let googleLogin = String(localized: "login.google_login", defaultValue: "구글 계정으로 로그인")
    static let kakaoLogin = String(localized: "login.kakao_login", defaultValue: "카카오톡으로 로그인")
    static let appleLogin = String(localized: "login.apple_login", defaultValue: "애플 계정으로 로그인")
}
