//
//  GoalDetailVM.swift
//  Dayme
//
//  Created by 정동천 on 12/12/24.
//

import Foundation
import Combine

final class GoalDetailVM: VM {
    @Published var goal: Goal
    
    private let goalService: GoalService = .shared
    
    init(goal: Goal) {
        self.goal = goal
        super.init()
    }
    
    override func bind() {
        let id = goal.id
        goalService.goals.dropFirst()
            .compactMap { goals in
                goals.first(where: { goal in goal.id == id })
            }.sink { [weak self] goal in
                self?.goal = goal
            }.store(in: &cancellables)
    }
}
