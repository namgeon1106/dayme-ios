//
//  AuthDTO.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import Foundation

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    
    func toDomain() -> OAuthToken {
        OAuthToken(accessToken: accessToken, refreshToken: refreshToken)
    }
}
