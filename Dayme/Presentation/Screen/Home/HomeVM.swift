//
//  HomeVM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

final class HomeVM: VM {
    @Published var nickname: String = "OOO"
    @Published var selectedDate = Date()
    @Published var weekDates: [Date] = Calendar.current.weekDates(from: Date())
    
    private let userService: UserService = .shared
    
    
    override func bind() {
        userService.user.compactMap { $0 }
            .sink { [weak self] user in
                self?.nickname = user.nickname
            }.store(in: &cancellables)
    }
}
