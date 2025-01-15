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
    let histories: [History]
    
    var currentHistory: History? {
        let now = Date()
        return histories.first(where: { history in
            now < history.executeDate || now.isSameDay(with: history.executeDate)
        }) ?? histories.last // 기간이 모두 지난 경우 마지막 History
    }
    
    var isCompleted: Bool {
        currentHistory?.status ?? false
    }
    
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
            histories: []
        )
    }
    
    func copyWith(
        id: Int? = nil,
        title: String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        repeatDays: [String]? = nil,
        histories: [History]? = nil
    ) -> Checklist {
        Checklist(
            id: id ?? self.id,
            title: title ?? self.title,
            startDate: startDate ?? self.startDate,
            endDate: endDate ?? self.endDate,
            repeatDays: repeatDays ?? self.repeatDays,
            histories: histories ?? self.histories
        )
    }
}

extension Checklist {
    struct History {
        let id: Int
        let status: Bool
        let executeDate: Date
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
        histories: [
            .init(id: 2, status: true, executeDate: .now),
            .init(id: 2, status: true, executeDate: .now.addingDays(7)),
        ]
    )
]
#endif

let onboarding6Checklist = Checklist(
    id: 1,
    title: "하루 7천보 걷기",
    startDate: Date.now,
    endDate: Date.now.addingDays(10),
    repeatDays: [],
    histories: []
)
