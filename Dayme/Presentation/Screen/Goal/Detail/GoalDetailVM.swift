//
//  GoalDetailVM.swift
//  Dayme
//
//  Created by 정동천 on 12/12/24.
//

import Foundation
import Combine

final class GoalDetailVM: VM {
    @Published private(set) var goal: Goal
    @Published private(set) var isDisplayLimited: Bool = false
    
    private let goalService: GoalService = .shared
    
    init(goal: Goal) {
        self.goal = goal
        super.init()
    }
    
    func toggleDisplayHome() async throws {
        let toggled = !goal.displayHome
        let newGoal = goal.copyWith(displayHome: toggled)
        try await goalService.editGoal(newGoal)
    }
    
    override func bind() {
        let id = goal.id
        goalService.goals
            .dropFirst() // 초기값은 버리고 업데이트만 반영
            .compactMap { goals in
                goals.first(where: { goal in goal.id == id })
            }.sink { [weak self] goal in
                self?.goal = goal
            }.store(in: &cancellables)
        
        if !goal.displayHome {
            goalService.goals.map { goals in
                let displayCount = goals.filter(\.displayHome).count
                let maximumCount = 3
                return displayCount >= maximumCount
            }
            .sink { [weak self] limited in
                self?.isDisplayLimited = limited
            }.store(in: &cancellables)
        }
    }
}
