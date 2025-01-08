//
//  UserDefault.swift
//  Dayme
//
//  Created by 정동천 on 12/1/24.
//

import Foundation

enum UserDefault {
    @UserDefaultPrimitive(key: .visitCount, defaultValue: 0)
    static var visitCount: Int!
    
    @UserDefaultPrimitive(key: .loggedIn, defaultValue: false)
    static var loggedIn: Bool!
    
    @UserDefaultCodable(key: .socialLogin)
    static var socialLogin: OAuthProvider?
    
    @UserDefaultPrimitive(key: .finishedOnboarding, defaultValue: false)
    static var finishedOnboarding: Bool!
}
