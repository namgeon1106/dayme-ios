//
//  L10n.swift
//  Dayme
//
//  Created by 정동천 on 11/10/24.
//

import Foundation

enum L10n {
    enum Login {}
    enum Terms {}
}

extension L10n.Login {
    static let subTitle = String(localized: "login.subTitle",
                                 defaultValue: "더 나은 내일의 나를 위한 시작,\n지금 함께해보세요.")
    static let googleLogin = String(localized: "login.google_login",
                                    defaultValue: "구글 계정으로 로그인")
    static let kakaoLogin = String(localized: "login.kakao_login",
                                   defaultValue: "카카오톡으로 로그인")
    static let appleLogin = String(localized: "login.apple_login",
                                   defaultValue: "애플 계정으로 로그인")
}

extension L10n.Terms {
    static let subTitle = String(localized: "terms.subTitle",
                                 defaultValue: "서비스 이용을 위해\n이용약관 동의가 필요해요.")
    static let start = String(localized: "terms.start",
                              defaultValue: "시작하기")
    static let agreeAll = String(localized: "terms.agreeAll",
                                 defaultValue: "모두 동의하기")
    static let termsOfService = String(localized: "terms.termsOfService",
                                       defaultValue: "[필수] 서비스 이용약관 동의")
    static let privacyPolicy = String(localized: "terms.privacyPolicy",
                                      defaultValue: "[필수] 개인정보 처리방침 동의")
}
