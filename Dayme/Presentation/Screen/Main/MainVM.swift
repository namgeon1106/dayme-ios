//
//  MainVM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

final class MainVM: VM {
    
    private let goalService: GoalService = .shared
    
    
    override func fetch() async {
        do {
            try await goalService.getGoals()
        } catch {
            Logger.error(error)
        }
    }
    
}
