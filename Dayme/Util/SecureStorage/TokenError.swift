//
//  TokenError.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import Foundation

enum TokenError: LocalizedError {
    case emptyAccessToken
    
    var errorDescription: String? {
        switch self {
        case .emptyAccessToken:
            "액세스 토큰이 비어있습니다."
        }
    }
}
