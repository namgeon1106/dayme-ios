//
//  Goal.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import Foundation

struct Goal: Equatable, Identifiable {
    let id: Int
    let title: String
    let emoji: String
    let startDate: Date
    let endDate: Date
    let hex: String
    let displayHome: Bool
    let progress: Double
    let subgoals: [Subgoal]
    let checklists: [Checklist]
    
    
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        lhs.id == rhs.id
    }
    
    static func create(
        title: String,
        emoji: String,
        startDate: Date,
        endDate: Date,
        hex: String,
        displayHome: Bool
    ) -> Goal {
        Goal(
            id: 0,
            title: title,
            emoji: emoji,
            startDate: startDate,
            endDate: endDate,
            hex: hex,
            displayHome: displayHome,
            progress: 0,
            subgoals: [],
            checklists: []
        )
    }
    
    func copyWith(
        id: Int? = nil,
        title: String? = nil,
        emoji: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        hex: String? = nil,
        displayHome: Bool? = nil,
        progress: Double? = nil,
        subgoals: [Subgoal]? = nil,
        checklists: [Checklist]? = nil
    ) -> Goal {
        Goal(
            id: id ?? self.id,
            title: title ?? self.title,
            emoji: emoji ?? self.emoji,
            startDate: startDate ?? self.startDate,
            endDate: endDate ?? self.endDate,
            hex: hex ?? self.hex,
            displayHome: displayHome ?? self.displayHome,
            progress: progress ?? self.progress,
            subgoals: subgoals ?? self.subgoals,
            checklists: checklists ?? self.checklists
        )
    }
}

#if DEBUG
let mockGoals: [Goal] = [
    Goal(
        id: 1,
        title: "Dayme 앱 출시하기",
        emoji: "🚀",
        startDate: Date().addingDays(-20),
        endDate: Date().addingDays(100),
        hex: "#FF0000",
        displayHome: true,
        progress: 0.5,
        subgoals: [],
        checklists: (0 ..< 10).flatMap { _ in mockChecklists }
    )
]
#endif
