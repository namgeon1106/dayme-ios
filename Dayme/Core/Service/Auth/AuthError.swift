//
//  AuthError.swift
//  Dayme
//
//  Created by 정동천 on 11/7/24.
//

import Foundation

enum AuthError: LocalizedError {
    case emptySocialToken
    case emptyRefreshToken
    case failedKakaoLogin
    case canceled
    case refreshTokenExpired
    
    var errorDescription: String? {
        switch self {
        case .emptySocialToken:
            "소셜 로그인 토큰을 가져오지 못했습니다."
        case .emptyRefreshToken:
            "리프레쉬 토큰을 가져오지 못했습니다."
        case .failedKakaoLogin:
            "알 수 없는 이유로 카카오 로그인에 실패하였습니다."
        case .canceled:
            "로그인을 취소했습니다."
        case .refreshTokenExpired:
            "로그인이 만료되었습니다."
        }
    }
}
