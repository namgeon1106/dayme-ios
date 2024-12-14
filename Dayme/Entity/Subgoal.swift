//
//  Subgoal.swift
//  Dayme
//
//  Created by 정동천 on 12/13/24.
//

import Foundation

struct Subgoal: Equatable, Identifiable {
    let id: Int
    let title: String
    let category: String
    let startDate: Date
    let endDate: Date
    let progress: Double
    
    
    static func == (lhs: Subgoal, rhs: Subgoal) -> Bool {
        lhs.id == rhs.id
    }
    
    static func create(
        title: String,
        category: String,
        startDate: Date,
        endDate: Date
    ) -> Subgoal {
        Subgoal(
            id: 0,
            title: title,
            category: category,
            startDate: startDate,
            endDate: endDate,
            progress: 0
        )
    }
    
    func copyWith(
        id: Int? = nil,
        title: String? = nil,
        category: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        progress: Double? = nil
    ) -> Subgoal {
        Subgoal(
            id: id ?? self.id,
            title: title ?? self.title,
            category: category ?? self.category,
            startDate: startDate ?? self.startDate,
            endDate: endDate ?? self.endDate,
            progress: progress ?? self.progress
        )
    }
}

#if DEBUG
let mockSubgoals: [Subgoal] = [
    Subgoal(
        id: 1,
        title: "Dayme 앱 프론트 개발",
        category: "iOS",
        startDate: Date().addingDays(-20),
        endDate: Date().addingDays(30),
        progress: 0.37
    )
]
#endif
