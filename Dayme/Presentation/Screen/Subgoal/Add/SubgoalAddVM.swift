//
//  SubgoalAddVM.swift
//  Dayme
//
//  Created by 정동천 on 12/14/24.
//

import Foundation
import Combine

final class SubgoalAddVM: VM {
    @Published var goal: Goal
    @Published var goals: [Goal] = []
    @Published var title: String = ""
    @Published var category: String = ""
    @Published var categories: [String] = ["+"]
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published private(set) var isValidate: Bool = false
    
    private let goalService: GoalService = .shared
    
    
    init(goal: Goal) {
        self.goal = goal
        super.init()
    }
    
    
    override func bind() {
        goalService.ongoingGoals.sink { [weak self] goals in
            self?.goals = goals
        }.store(in: &cancellables)
        
        goalService.allGoals.sink { [weak self] goals in
            let defaultCategories = ["+", "건강", "재테크", "자기계발", "여가"]
            let userCategories = goals.flatMap(\.subgoals).map(\.category)
            self?.categories = (defaultCategories + userCategories).removeDuplicates()
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

extension SubgoalAddVM {
    
    func addSubgoal() async throws {
        guard let startDate, let endDate else {
            throw NSError(domain: "목표 추가 파라미터 누락", code: 1001)
        }
        
        let subgoal = Subgoal.create(
            title: title,
            category: category,
            startDate: startDate,
            endDate: endDate
        )
        
        try await goalService.createSubgoal(goalId: goal.id, subgoal)
    }
    
    func addCategory(_ category: String) {
        if !categories.contains(category) {
            categories += [category]
        }
        
        self.category = category
    }
    
}
