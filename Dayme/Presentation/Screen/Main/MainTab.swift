//
//  MainTab.swift
//  Dayme
//
//  Created by 정동천 on 11/24/24.
//

import UIKit

enum MainTab: Int, CaseIterable {
    
    case home, goal, setting
    
    
    var tag: Int { rawValue }
    
    var title: String {
        return switch self {
        case .home: "홈"
        case .goal: "목표관리"
        case .setting: "설정"
        }
    }
    
    var image: UIImage {
        return switch self {
        case .home: .icTabHome
        case .goal: .icTabGoal
        case .setting: .icTabSetting
        }
    }
    
}
