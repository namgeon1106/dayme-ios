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
    static let emailTF = String(localized: "login.email_text_field", defaultValue: "이메일을 입력해주세요")
    static let pwTF = String(localized: "login.password_text_field", defaultValue: "비밀번호을 입력해주세요")
    static let loginButton = String(localized: "login.login_button", defaultValue: "로그인")
    static let separataor = String(localized: "login.login_separator", defaultValue: "혹은")
    static let googleLogin = String(localized: "login.google_login", defaultValue: "구글 계정으로 로그인")
    static let kakaoLogin = String(localized: "login.kakao_login", defaultValue: "카카오톡으로 로그인")
    static let appleLogin = String(localized: "login.apple_login", defaultValue: "애플 계정으로 로그인")
}
