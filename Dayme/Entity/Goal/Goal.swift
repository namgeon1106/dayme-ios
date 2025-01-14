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
    var subgoals: [Subgoal]
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
        subgoals: mockSubgoals,
        checklists: (0 ..< 10).flatMap { _ in mockChecklists }
    )
]
#endif

let onboarding3DummyGoal = Goal(
    id: 0, title: "주요목표 타이틀", emoji: "⛰️", startDate: Date.now, endDate: Date.now.addingTimeInterval(365 * 24 * 3600), hex: "000000", displayHome: false, progress: 0, subgoals: [], checklists: [])

let onboarding4DummyGoal = Goal(
    id: 0,
    title: "2025년 동안 5kg 감량하기",
    emoji: "👩‍💻",
    startDate: Date.now,
    endDate: Date.now.addingTimeInterval(365 * 24 * 3600),
    hex: "000000",
    displayHome: false,
    progress: 0,
    subgoals: [],
    checklists: []
)

let onboarding5Subgoal = Subgoal(
    id: 0,
    title: "월 10회 이상 유산소 운동(러닝, 자전거 등) 진행하기",
    category: "건강",
    startDate: Date.now,
    endDate: Date.now.addingTimeInterval(183 * 24 * 3600),
    progress: 0.49,
    checklists: []
)
