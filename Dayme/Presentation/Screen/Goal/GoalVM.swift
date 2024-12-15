//
//  GoalVM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

final class GoalVM: VM {
    @Published var isMenuHidden: Bool = true
    @Published var isFABHidden: Bool = true
    @Published var goals: [Goal] = []
    
    private let service: GoalService = .shared
    
    
    override func bind() {
        service.goals
            .sink { [weak self] goals in
                self?.goals = goals
            }.store(in: &cancellables)
        
        service.goals.map(\.isEmpty)
            .sink { [weak self] isEmpty in
                self?.isFABHidden = isEmpty
            }.store(in: &cancellables)
    }
}
