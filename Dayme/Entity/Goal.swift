//
//  Goal.swift
//  Dayme
//
//  Created by 정동천 on 12/5/24.
//

import Foundation

struct GoalTrackingItem {
    let emoji: String
    let title: String
    let progress: Double
    let hex: String
}

#if DEBUG
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
#endif
