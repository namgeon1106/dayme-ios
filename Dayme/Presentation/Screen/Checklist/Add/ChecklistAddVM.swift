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
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var selectedWeekDays: Set<Int> = []
    
    @Published var goal: Goal
    @Published var subgoal: Subgoal?
    @Published private(set) var goals: [Goal] = []
    @Published private(set) var isValidate: Bool = false
    
    let weekDays: [Int] = [2, 3, 4, 5, 6, 7, 1] // 월 ~ 일
    private let goalService: GoalService = .shared
    
    
    init(goal: Goal, subgoal: Subgoal?) {
        self.goal = goal
        self.subgoal = subgoal
        self.startDate = subgoal?.startDate ?? goal.startDate
        self.endDate = subgoal?.endDate ?? goal.endDate
        super.init()
    }
    
    
    override func bind() {
        Publishers.CombineLatest4(
            $title.map({ !$0.isEmpty }),
            $startDate.map({ $0 != nil }),
            $endDate.map({ $0 != nil }),
            $selectedWeekDays.map({ !$0.isEmpty })
        )
        .map { $0 && $1 && $2 && $3 }
        .assign(to: &$isValidate)
        
        goalService.ongoingGoals.sink { [weak self] goals in
            self?.goals = goals
        }.store(in: &cancellables)
        
        $title
            .map({ !$0.isEmpty })
            .assign(to: &$isValidate)
    }
    
}

extension ChecklistAddVM {
    
    func addChecklist() async throws {
        guard let startDate, let endDate else {
            throw NSError(domain: "목표 추가 파라미터 누락", code: 1001)
        }
        
        let weekDaysTitle = ["일", "월", "화", "수", "목", "금", "토"]
        let repeatDays = weekDays
            .filter(selectedWeekDays.contains)
            .compactMap { weekDaysTitle[orNil: $0 - 1] }
        
        let checklist = Checklist.create(
            title: title,
            startDate: startDate,
            endDate: endDate,
            repeatDays: repeatDays
        )
        
        try await goalService.createChecklist(
            goalId: goal.id,
            subgoalId: subgoal?.id,
            checklist
        )
    }
    
}
