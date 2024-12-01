//
//  UserDefaultKey.swift
//  Dayme
//
//  Created by 정동천 on 12/1/24.
//

import Foundation

enum UserDefaultKey: String {
    case socialLogin
    case loggedIn
    case visitCount
    
    var path: String {
        "dayme_userdefaults_\(rawValue)"
    }
}
