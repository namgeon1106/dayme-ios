//
//  GoalDTO.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import Foundation

struct GoalResponse: Decodable {
    let id: Int
    let title: String
    let emoji: String
    let startDate: String
    let endDate: String
    let achievementRate: Int
    let color: String
    let isHomeView: Bool
    let subGoals: [SubgoalResponse]
    
    func toDomain() -> Goal? {
        guard let startDate = Date.string(startDate, style: .standard),
              let endDate = Date.string(endDate, style: .standard) else {
            return nil
        }
        
        return Goal(
            id: id,
            title: title,
            emoji: emoji,
            startDate: startDate,
            endDate: endDate,
            hex: color,
            displayHome: isHomeView,
            progress: Double(achievementRate) / 100,
            subgoals: subGoals.compactMap { $0.toDomain() }
        )
    }
}

struct SubgoalResponse: Decodable {
    let id: Int
    let title: String
    let category: String
    let startDate: String
    let endDate: String
    let achievementRate: Int
    
    func toDomain() -> Subgoal? {
        guard let startDate = Date.string(startDate, style: .standard),
              let endDate = Date.string(endDate, style: .standard) else {
            return nil
        }
        
        return Subgoal(
            id: id,
            title: title,
            category: category,
            startDate: startDate,
            endDate: endDate,
            progress: Double(achievementRate) / 100
        )
    }
}

struct AddGoalRequest: Encodable {
    let title: String
    let emoji: String
    let startDate: String
    let endDate: String
    let color: String
    let isHomeView: Bool
    
    static func fromDomain(_ goal: Goal) -> AddGoalRequest {
        AddGoalRequest(
            title: goal.title,
            emoji: goal.emoji,
            startDate: goal.startDate.string(style: .standard),
            endDate: goal.endDate.string(style: .standard),
            color: goal.hex,
            isHomeView: goal.displayHome
        )
    }
}

struct AddSubgoalRequest: Encodable {
    let title: String
    let category: String
    let startDate: String
    let endDate: String
    
    static func fromDomain(_ subgoal: Subgoal) -> AddSubgoalRequest {
        AddSubgoalRequest(
            title: subgoal.title,
            category: subgoal.category,
            startDate: subgoal.startDate.string(style: .standard),
            endDate: subgoal.endDate.string(style: .standard)
        )
    }
}
