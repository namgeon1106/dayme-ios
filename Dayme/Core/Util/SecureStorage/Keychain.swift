//
//  Keychain.swift
//  Dayme
//
//  Created by 정동천 on 11/6/24.
//

import Foundation
import Security

class Keychain {
    
    private init() {}
    
    class func create(key: String, token: String) {
        let data = token.data(using: .utf8, allowLossyConversion: false)
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data as Any
        ]
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "키체인 토큰 저장 실패")
    }
    
    class func read(key: String) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            return (dataTypeRef as? Data).flatMap({ retrievedData in
                String(data: retrievedData, encoding: .utf8)
            })
        }
        
        Logger.error { "키체인 읽기 실패, status: \(status)" }
        return nil
    }
    
    class func delete(key: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        let status = SecItemDelete(query)
        assert(status == noErr, "키체인 삭제 실패, status: \(status)")
    }
    
}
