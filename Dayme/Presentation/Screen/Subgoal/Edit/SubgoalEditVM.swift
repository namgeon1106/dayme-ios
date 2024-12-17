//
//  SubgoalEditVM.swift
//  Dayme
//
//  Created by 정동천 on 12/17/24.
//

import Foundation
import Combine

final class SubgoalEditVM: VM {
    @Published var goal: Goal
    @Published var goals: [Goal] = []
    @Published var title: String
    @Published var category: String
    @Published var categories: [String] = ["+"]
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published private(set) var isValidate: Bool = false
    
    private let originalGoal: Goal
    private let originalSubgoal: Subgoal
    private let goalService: GoalService = .shared
    
    
    init(goal: Goal, subgoal: Subgoal) {
        self.goal = goal
        self.originalGoal = goal
        self.originalSubgoal = subgoal
        self.title = subgoal.title
        self.category = subgoal.category
        self.startDate = subgoal.startDate
        self.endDate = subgoal.endDate
        super.init()
    }
    
    
    override func bind() {
        let defaultGoals = ["+", "건강", "재테크", "자기계발", "여가"]
        goalService.goals.sink { [weak self] goals in
            self?.goals = goals
            self?.categories = defaultGoals + goals
                .flatMap(\.subgoals)
                .map(\.category)
                .removeDuplicates()
        }.store(in: &cancellables)
        
        Publishers.CombineLatest4(
            $title.map({ !$0.isEmpty }),
            $category.map({ !$0.isEmpty }),
            $startDate.map({ $0 != nil }),
            $endDate.map({ $0 != nil })
        )
        .map { $0 && $1 && $2 && $3 }
        .assign(to: &$isValidate)
    }
    
}

extension SubgoalEditVM {
    
    func editSubgoal() async throws {
        guard let startDate, let endDate else {
            throw NSError(domain: "목표 추가 파라미터 누락", code: 1001)
        }
        
        if goal == originalGoal { // 상위목표가 유지된 경우
            let newSubgoal = originalSubgoal.copyWith(
                title: title,
                category: category,
                startDate: startDate,
                endDate: endDate
            )
            try await goalService.editSubgoal(goalId: goal.id, newSubgoal)
        } else { // 상위목표가 변경된 경우
            let newSubgoal = Subgoal.create(
                title: title,
                category: category,
                startDate: startDate,
                endDate: endDate
            )
            try await goalService.createSubgoal(goalId: goal.id, newSubgoal)
            try await goalService.deleteSubgoal(goalId: originalGoal.id, subgoalId: originalSubgoal.id)
        }
    }
    
    func deleteSubgoal() async throws {
        try await goalService.deleteSubgoal(goalId: originalGoal.id, subgoalId: originalSubgoal.id)
    }
    
    func addCategory(_ category: String) {
        if !categories.contains(category) {
            categories += [category]
        }
        
        self.category = category
    }
    
}
