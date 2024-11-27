//
//  Terms.swift
//  Dayme
//
//  Created by 정동천 on 11/27/24.
//

import Foundation

enum Terms {
    case termsOfService
    case privacyPolicy
    
    var title: String {
        switch self {
        case .termsOfService: L10n.TermsDetail.termsOfServiceTitle
        case .privacyPolicy: L10n.TermsDetail.privacyPolicyTitle
        }
    }
    
    var content: String {
        switch self {
        case .termsOfService: L10n.TermsDetail.termsOfServiceContent
        case .privacyPolicy: L10n.TermsDetail.privacyPolicyContent
        }
    }
}
