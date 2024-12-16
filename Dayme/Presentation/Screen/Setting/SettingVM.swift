//
//  SettingVM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

final class SettingVM: VM {
    @Published private(set) var nickname: String = ""
    
    private let authService: AuthService = .init()
    private let userService: UserService = .shared
    
    
    override func bind() {
        userService.user.compactMap(\.?.nickname)
            .sink { [weak self] nickname in
                self?.nickname = nickname
            }.store(in: &cancellables)
    }
    
    func logout() async throws {
        try await authService.logout()
    }
    
    func deleteUser() async throws {
        try await userService.deleteUser()
    }
    
}
