//
//  GoalPageVM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

final class GoalPageVM: VM {
    @Published var ongoingGoals: [Goal] = []
    @Published var pastGoals: [Goal] = []
    
    private let service: GoalService = .shared
    
    
    override func bind() {
        service.goals.sink { [weak self] goals in
            var ongoingGoals: [Goal] = []
            var pastGoals: [Goal] = []
            
            let now = Date()
            for goal in goals {
                if now > goal.endDate, !now.isSameDay(with: goal.endDate) {
                    pastGoals.append(goal)
                } else {
                    ongoingGoals.append(goal)
                }
            }
            
            self?.ongoingGoals = ongoingGoals
            self?.pastGoals = pastGoals
        }.store(in: &cancellables)
    }
    
}
