//
//  SettingVM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

final class SettingVM: VM {
    
    private let authService: AuthService = .init()
    private let userService: UserService = .shared
    
    
    func logout() async throws {
        try await authService.logout()
    }
    
    func deleteUser() async throws {
        try await userService.deleteUser()
    }
    
}
