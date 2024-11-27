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
    enum TermsDetail {}
    enum Nickname {}
}

extension L10n.Login {
    static let subTitle = String(localized: "login.subTitle")
    static let googleLogin = String(localized: "login.google_login")
    static let kakaoLogin = String(localized: "login.kakao_login")
    static let appleLogin = String(localized: "login.apple_login")
}

extension L10n.Terms {
    static let subTitle = String(localized: "terms.subTitle")
    static let start = String(localized: "terms.start")
    static let agreeAll = String(localized: "terms.agreeAll")
    static let termsOfService = String(localized: "terms.termsOfService")
    static let privacyPolicy = String(localized: "terms.privacyPolicy")
}

extension L10n.TermsDetail {
    static let termsOfServiceTitle = String(localized: "terms_detail.terms_of_service_title")
    static let termsOfServiceContent = String(localized: "terms_detail.terms_of_service_content")
    static let privacyPolicyTitle = String(localized: "terms_detail.privacy_policy_title")
    static let privacyPolicyContent = String(localized: "terms_detail.privacy_policy_content")
}

extension L10n.Nickname {
    static let subTitle = String(localized: "nickname.subTitle")
    static let done = String(localized: "nickname.done")
    static let caption = String(localized: "nickname.caption")
    static let placeholder = String(localized: "nickname.placeholder")
}
