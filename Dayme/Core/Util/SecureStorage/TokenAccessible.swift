//
//  TokenAccessible.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import Foundation

protocol TokenAccessible {}

extension TokenAccessible {
    
    func getAccessToken() throws -> String {
        if let token = Keychain.read(key: Env.Keychain.accessTokenKey) {
            return token
        }
        
        throw TokenError.emptyAccessToken
    }
    
    func removeToken() {
        Keychain.delete(key: Env.Keychain.accessTokenKey)
        Keychain.delete(key: Env.Keychain.refreshTokenKey)
    }
    
}


