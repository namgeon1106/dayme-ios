//
//  GoalPageVM.swift
//  Dayme
//
//  Created by 정동천 on 12/8/24.
//

import Foundation
import Combine

final class GoalPageVM: VM {
    @Published var ongoingGoals: [Goal] = []
    @Published var pastGoals: [Goal] = []
    @Published var finishedOnboarding = UserDefault.finishedOnboarding!
    @Published var fetchedOngoingGoals: [Goal] = []
    
    private let service: GoalService = .shared
    
    
    override func bind() {
        service.ongoingGoals
            .assign(to: &$fetchedOngoingGoals)
        
        $fetchedOngoingGoals.combineLatest($finishedOnboarding)
            .map { fetchedOngoingGoals, finishedOnboarding in
                finishedOnboarding ? fetchedOngoingGoals : [onboarding3DummyGoal]
            }
            .assign(to: &$ongoingGoals)
        
        service.pastGoals.sink { [weak self] goals in
            self?.pastGoals = goals
        }.store(in: &cancellables)
    }
    
    
    func refresh() {
        service.refreshGoalsState()
    }
}
