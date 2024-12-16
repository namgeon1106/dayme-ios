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
    let isCompleted: Bool
    
    
    static func == (lhs: Checklist, rhs: Checklist) -> Bool {
        lhs.id == rhs.id
    }
    
    static func create(title: String) -> Checklist {
        Checklist(id: 0, title: title, isCompleted: false)
    }
    
    func copyWith(id: Int? = nil, title: String? = nil, isCompleted: Bool? = nil) -> Checklist {
        Checklist(
            id: id ?? self.id,
            title: title ?? self.title,
            isCompleted: isCompleted ?? self.isCompleted
        )
    }
}

#if DEBUG
let mockChecklists: [Checklist] = [
    Checklist(
        id: 1,
        title: "Dayme 앱 프론트 개발",
        isCompleted: false
    )
]
#endif
