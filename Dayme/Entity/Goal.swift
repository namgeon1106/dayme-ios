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
            progress: 0
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
        progress: Double? = nil
    ) -> Goal {
        Goal(
            id: id ?? self.id,
            title: title ?? self.title,
            emoji: emoji ?? self.emoji,
            startDate: startDate ?? self.startDate,
            endDate: endDate ?? self.endDate,
            hex: hex ?? self.hex,
            displayHome: displayHome ?? self.displayHome,
            progress: progress ?? self.progress
        )
    }
}

struct GoalTrackingItem {
    let emoji: String
    let title: String
    let progress: Double
    let hex: String
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
        progress: 0.5
    )
]
#endif

//#if DEBUG
let mockGoalTrackingItems: [GoalTrackingItem] = [
    GoalTrackingItem(
        emoji: "✍",
        title: "토익 900점 달성",
        progress: 0.49,
        hex: "#FF0000"
    ),
    GoalTrackingItem(
        emoji: "👩‍💻",
        title: "25년 상반기 UXUI디자이너로 이직",
        progress: 0.32,
        hex: "#9747FF"
    ),
    GoalTrackingItem(
        emoji: "🏋️‍♀️",
        title: "몸무게 5kg 감량하기",
        progress: 0.16,
        hex: "#00EF89"
    ),
]
//#endif
