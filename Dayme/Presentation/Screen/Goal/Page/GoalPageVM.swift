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
        service.ongoingGoals.sink { [weak self] goals in
            self?.ongoingGoals = goals
        }.store(in: &cancellables)
        
        service.pastGoals.sink { [weak self] goals in
            self?.pastGoals = goals
        }.store(in: &cancellables)
    }
    
    
    func refresh() {
        service.refreshGoalsState()
    }
}
