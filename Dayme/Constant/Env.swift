//
//  Env.swift
//  Dayme
//
//  Created by 정동천 on 11/6/24.
//

import Foundation

enum Env {
    enum Keychain {
        static let accessTokenKey: String = infoValue("KEYCHAIN_ACCESS_TOKEN_KEY")
        static let refreshTokenKey: String = infoValue("KEYCHAIN_REFRESH_TOKEN_KEY")
    }
    
    static let serverBaseUrl: String = infoValue("SERVER_BASE_URL")
    
    static let kakakoAppKey: String = infoValue("KAKAO_APP_KEY")
}

private extension Env {
    
    static func infoValue<T>(_ key: String) -> T {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.Plist 파일이 누락되었습니다.")
        }
        
        guard let rawValue = infoDictionary[key] else {
            fatalError("Info.Plist 내에서 \(key)가 정의되지 않았습니다.")
        }
        
        guard let value = rawValue as? T else {
            fatalError("잘못된 타입입니다. 예상 타입: \(T.self)")
        }
        
        return value
    }
    
}
