//
//  GoalDetailVM.swift
//  Dayme
//
//  Created by 정동천 on 12/12/24.
//

import Foundation
import Combine

final class GoalDetailVM: VM {
    @Published var goal: Goal
    
    init(goal: Goal) {
        self.goal = goal
        super.init()
    }
}
