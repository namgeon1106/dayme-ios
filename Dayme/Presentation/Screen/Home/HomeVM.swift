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
    @Published var goals: [Goal] = []
    @Published var weekDates: [Date] = Calendar.current.weekDates(from: Date())
    @Published private(set) var checklistDateItems: [ChecklistDateItem] = []
    
    private let userService: UserService = .shared
    private let goalService: GoalService = .shared
    
    
    func toggleChecklist(goalId: Int, historyId: Int) async throws {
        try await goalService.toggleChecklistHistory(goalId: goalId, historyId: historyId)
    }
    
    override func bind() {
        userService.user.compactMap { $0 }
            .sink { [weak self] user in
                self?.nickname = user.nickname
            }.store(in: &cancellables)
        
        goalService.allGoals.map { $0.filter(\.displayHome) }
            .sink { [weak self] goals in
                self?.goals = goals
            }.store(in: &cancellables)
        
        let backgroundQueue = DispatchQueue.global(qos: .userInitiated)
        Publishers.CombineLatest($goals, $selectedDate)
            .subscribe(on: backgroundQueue)
            .map { goals, date -> AnyPublisher<[ChecklistDateItem], Never> in
                Just(goals.compactMap { goal in
                    ChecklistDateItem(goal: goal, date: date)
                }).eraseToAnyPublisher()
            }
            .switchToLatest()
            .assign(to: &$checklistDateItems)
        
    }
}
