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
//    let achievementRate: Int
    let color: String
    let isHomeView: Bool
    
    func toDomain() -> Goal? {
        guard let startDate = Date.string(startDate, style: .api),
              let endDate = Date.string(endDate, style: .api) else {
            return nil
        }
        
        return Goal(
            id: id,
            title: title,
            emoji: emoji,
            startDate: startDate,
            endDate: endDate,
            hex: color,
            displayHome: isHomeView
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
            startDate: goal.startDate.string(style: .api),
            endDate: goal.endDate.string(style: .api),
            color: goal.hex,
            isHomeView: goal.displayHome
        )
    }
}
