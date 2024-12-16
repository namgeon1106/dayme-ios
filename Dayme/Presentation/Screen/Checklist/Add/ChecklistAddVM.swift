//
//  ChecklistAddVM.swift
//  Dayme
//
//  Created by 정동천 on 12/16/24.
//

import Foundation
import Combine

final class ChecklistAddVM: VM {
    @Published var title: String = ""
    @Published var goal: Goal
    @Published var subgoal: Subgoal?
    @Published private(set)var goals: [Goal] = []
    @Published private(set) var isValidate: Bool = false
    
    private let goalService: GoalService = .shared
    
    
    init(goal: Goal, subgoal: Subgoal?) {
        self.goal = goal
        self.subgoal = subgoal
        super.init()
    }
    
    
    override func bind() {
        goalService.goals.sink { [weak self] goals in
            self?.goals = goals
        }.store(in: &cancellables)
        
        $title
            .map({ !$0.isEmpty })
            .assign(to: &$isValidate)
    }
    
}

extension ChecklistAddVM {
    
    func addChecklist() async throws {
        let checklist = Checklist.create(title: title)
        
        try await goalService.createChecklist(
            goalId: goal.id,
            subgoalId: subgoal?.id,
            checklist
        )
    }
    
}
