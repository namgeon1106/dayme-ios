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
    @Published var finishedOnboarding = UserDefault.finishedOnboarding!
    @Published var fetchedGoals: [Goal] = []
    
    @Published var ongoingGoals: [Goal] = []
    @Published var pastGoals: [Goal] = []
    @Published var fetchedOngoingGoals: [Goal] = []
    
    
    private let service: GoalService = .shared
    
    
    override func bind() {
        service.allGoals
            .sink { [weak self] goals in
                self?.fetchedGoals = goals
            }.store(in: &cancellables)
        
        $fetchedGoals.combineLatest($finishedOnboarding)
            .sink { [weak self] fetchedGoals, finishedOnboarding in
                self?.goals = finishedOnboarding ? fetchedGoals : [onboarding3DummyGoal]
            }
            .store(in: &cancellables)
        
        service.allGoals.map(\.isEmpty)
            .sink { [weak self] isEmpty in
                self?.isFABHidden = isEmpty
            }.store(in: &cancellables)
        
        service.ongoingGoals
            .assign(to: &$fetchedOngoingGoals)
        
        $fetchedOngoingGoals.combineLatest($finishedOnboarding)
            .map { fetchedOngoingGoals, finishedOnboarding in
                print(finishedOnboarding ? fetchedOngoingGoals : [onboarding3DummyGoal])
                return finishedOnboarding ? fetchedOngoingGoals : [onboarding3DummyGoal]
            }
            .assign(to: &$ongoingGoals)
        
        service.pastGoals.sink { [weak self] goals in
            self?.pastGoals = goals
        }.store(in: &cancellables)
    }
    
    func hideOnboardingGuide() {
        finishedOnboarding = true
    }
    
    func refresh() {
        service.refreshGoalsState()
    }
}
