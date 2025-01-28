//
//  Setting.swift
//  Dayme
//
//  Created by 정동천 on 12/1/24.
//

import Foundation

enum Setting: String, CaseIterable {
    case privacyPolicy, logout, withdraw, sendFeedback, version
    
    var title: String {
        switch self {
        case .privacyPolicy:
            "개인정보 처리방침"
        case .logout:
            "로그아웃"
        case .withdraw:
            "탈퇴하기"
        case .sendFeedback:
            "피드백 보내기"
        case .version:
            "앱 버전"
        }
    }
}
