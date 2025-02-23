//
//  ChecklistDateItem.swift
//  Dayme
//
//  Created by 정동천 on 12/21/24.
//

import Foundation

struct ChecklistDateItem {
    let date: Date
    let subgoal: Subgoal
    let goalId: Int
    let goalEmoji: String
    let goalTitle: String
    let hex: String
    let checklists: [Checklist]
    
    init?(subgoal: Subgoal, goalId: Int, goalEmoji: String, goalTitle: String, hex: String, date: Date) {
        let filteredChecklists = subgoal.checklists.compactMap { checklist -> Checklist? in
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
            self.subgoal = subgoal
            self.goalId = goalId
            self.goalEmoji = goalEmoji
            self.goalTitle = goalTitle
            self.hex = hex
            self.checklists = filteredChecklists
        }
    }
}

#if DEBUG
//let mockChecklistDateItem: [ChecklistDateItem] = [
//    ChecklistDateItem(goal: mockGoals[0], date: .now),
//    ChecklistDateItem(goal: mockGoals[0], date: .now),
//    ChecklistDateItem(goal: mockGoals[0], date: .now),
//].compactMap { $0 }
#endif
