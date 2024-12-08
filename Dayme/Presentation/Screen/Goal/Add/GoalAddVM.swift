//
//  GoalAddVM.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import Foundation
import Combine

final class GoalAddVM: ObservableObject {
    @Published var emoji: String = "🚀"
    @Published var title: String = ""
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var color: PalleteColor?
    @Published var displayeHome: Bool = false
    
    @Published private(set) var isValidate: Bool = false
    
    private let service: GoalService = .shared
    
    
    init() {
        bind()
    }
    
    
    func addGoal() async throws {
        guard let startDate, let endDate, let color else {
            throw NSError(domain: "목표 추가 파라미터 누락", code: 1001)
        }
        
        let goal = Goal.create(
            title: title,
            emoji: emoji,
            startDate: startDate,
            endDate: endDate,
            hex: color.hex,
            displayHome: displayeHome
        )
        try await service.createGoal(goal)
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
