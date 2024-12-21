//
//  ChecklistDateItem.swift
//  Dayme
//
//  Created by 정동천 on 12/21/24.
//

import Foundation

struct ChecklistDateItem {
    let date: Date
    let goal: Goal
    let checklists: [Checklist]
    
    init?(goal: Goal, date: Date) {
        let totalChecklists = goal.checklists + goal.subgoals.flatMap(\.checklists)
        let filteredChecklists = totalChecklists.compactMap { checklist -> Checklist? in
            let history = checklist.histories.first(where: { history in
                history.executeDate.isSameDay(with: date)
            })
            
            if let history {
                return checklist.copyWith(histories: [history])
            }
            return nil
        }
        
        if filteredChecklists.isEmpty {
            return nil
        } else {
            self.date = date
            self.goal = goal
            self.checklists = filteredChecklists
        }
    }
}

#if DEBUG
let mockChecklistDateItem: [ChecklistDateItem] = [
    ChecklistDateItem(goal: mockGoals[0], date: .now),
    ChecklistDateItem(goal: mockGoals[0], date: .now),
    ChecklistDateItem(goal: mockGoals[0], date: .now),
].compactMap { $0 }
#endif
