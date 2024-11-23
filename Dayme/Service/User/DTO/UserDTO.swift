//
//  UserDTO.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import Foundation

struct UserResponse: Decodable {
    let id: Int
    let nickname: String
    let email: String
    
    func toDomain() -> User {
        User(id: id, nickname: nickname, email: email)
    }
}
