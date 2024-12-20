//
//  ChecklistEditVM.swift
//  Dayme
//
//  Created by 정동천 on 12/21/24.
//

import Foundation
import Combine

final class ChecklistEditVM: VM {
    @Published var title: String
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var selectedWeekDays: Set<Int>
    
    @Published var goal: Goal
    @Published var subgoal: Subgoal?
    @Published private(set) var goals: [Goal] = []
    @Published private(set) var isValidate: Bool = false
    
    let weekDaysTitle = ["일", "월", "화", "수", "목", "금", "토"]
    let weekDays: [Int] = [2, 3, 4, 5, 6, 7, 1] // 월 ~ 일
    private let checklist: Checklist
    private let goalService: GoalService = .shared
    
    
    init(goal: Goal, subgoal: Subgoal?, checklist: Checklist) {
        self.checklist = checklist
        self.title = checklist.title
        self.goal = goal
        self.subgoal = subgoal
        self.startDate = checklist.startDate
        self.endDate = checklist.endDate
        let weekDayMapper = Dictionary(uniqueKeysWithValues: zip(weekDaysTitle, weekDays))
        self.selectedWeekDays = Set(checklist.repeatDays.compactMap { weekDayMapper[$0] })
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
        
        $goal.sink { [weak self] goal in
            self?.startDate = goal.startDate
            self?.endDate = goal.endDate
        }.store(in: &cancellables)
        
        $subgoal.compactMap({ $0 }).sink { [weak self] subgoal in
            self?.startDate = subgoal.startDate
            self?.endDate = subgoal.endDate
        }.store(in: &cancellables)
    }
    
}

extension ChecklistEditVM {
    
    func deleteChecklist() async throws {
        try await goalService.deleteChecklist(goalId: goal.id, checklistId: checklist.id)
    }
    
    func editChecklist() async throws {
        guard let startDate, let endDate else {
            throw NSError(domain: "목표 수정 파라미터 누락", code: 1001)
        }
        
        let repeatDays = weekDays
            .filter(selectedWeekDays.contains)
            .compactMap { weekDaysTitle[orNil: $0 - 1] }
        
        let newChecklist = checklist.copyWith(
            title: title,
            startDate: startDate,
            endDate: endDate,
            repeatDays: repeatDays
        )
        
        try await goalService.editChecklist(goalId: goal.id, newChecklist)
    }
    
}
