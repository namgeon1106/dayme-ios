//
//  Checklist.swift
//  Dayme
//
//  Created by 정동천 on 12/16/24.
//

import Foundation

struct Checklist: Equatable, Identifiable {
    let id: Int
    let title: String
    let startDate: Date
    let endDate: Date
    let repeatDays: [String]
    let isCompleted: Bool
    
    
    static func == (lhs: Checklist, rhs: Checklist) -> Bool {
        lhs.id == rhs.id
    }
    
    static func create(
        title: String,
        startDate: Date,
        endDate: Date,
        repeatDays: [String]
    ) -> Checklist {
        Checklist(
            id: 0,
            title: title,
            startDate: startDate,
            endDate: endDate,
            repeatDays: repeatDays,
            isCompleted: false
        )
    }
    
    func copyWith(
        id: Int? = nil,
        title: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        repeatDays: [String]? = nil,
        isCompleted: Bool? = nil
    ) -> Checklist {
        Checklist(
            id: id ?? self.id,
            title: title ?? self.title,
            startDate: startDate ?? self.startDate,
            endDate: endDate ?? self.endDate,
            repeatDays: repeatDays ?? self.repeatDays,
            isCompleted: isCompleted ?? self.isCompleted
        )
    }
}

#if DEBUG
let mockChecklists: [Checklist] = [
    Checklist(
        id: 1,
        title: "Dayme 앱 프론트 개발",
        startDate: Date().addingDays(-10),
        endDate: Date().addingDays(10),
        repeatDays: ["월", "수", "금"],
        isCompleted: false
    )
]
#endif
