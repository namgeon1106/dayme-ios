//
//  GoalEditVM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

final class GoalEditVM: ObservableObject {
    @Published var emoji: String
    @Published var title: String
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var color: PalleteColor?
    @Published var displayeHome: Bool
    
    @Published private(set) var isValidate: Bool = false
    
    let goal: Goal
    
    private let service: GoalService = .shared
    
    
    init(goal: Goal) {
        self.goal = goal
        self.emoji = goal.emoji
        self.title = goal.title
        self.startDate = goal.startDate
        self.endDate = goal.endDate
        self.color = .init(hex: goal.hex)
        self.displayeHome = goal.displayHome
        
        bind()
    }
    
    
    func editGoal() async throws {
        guard let color else {
            throw NSError(domain: "목표 추가 파라미터 누락", code: 1001)
        }
        
        let goal = goal.copyWith(
            title: title,
            emoji: emoji,
            startDate: startDate,
            endDate: endDate,
            hex: color.hex,
            displayHome: displayeHome
        )
        try await service.editGoal(goal)
    }
    
    func deleteGoal() async throws {
        try await service.deleteGoal(goal.id)
    }
    
    private func bind() {
        Publishers.CombineLatest4(
            $emoji.map({ !$0.isEmpty }),
            $title.map({ !$0.isEmpty }),
            $startDate.map({ $0 != nil }),
            $endDate.map({ $0 != nil })
        )
        .map { $0 && $1 && $2 && $3 }
        .combineLatest($color.map({ $0 != nil })) { $0 && $1 }
        .assign(to: &$isValidate)
    }
}
