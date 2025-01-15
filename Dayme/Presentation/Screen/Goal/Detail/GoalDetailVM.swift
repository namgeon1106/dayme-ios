//
//  GoalDetailVM.swift
//  Dayme
//
//  Created by 정동천 on 12/12/24.
//

import Foundation
import Combine

enum OnboardingPhase {
    case phase4
    case phase4_1
    case phase5
    case phase6
}

final class GoalDetailVM: VM {
    @Published private(set) var goal: Goal
    @Published private(set) var isDisplayLimited: Bool = false
    @Published private(set) var onboardingPhase: OnboardingPhase? = UserDefault.finishedOnboarding ? nil : .phase4
    
    private let goalService: GoalService = .shared
    
    init(goal: Goal) {
        self.goal = goal
        super.init()
    }
    
    func toggleDisplayHome() async throws {
        let toggled = !goal.displayHome
        let newGoal = goal.copyWith(displayHome: toggled)
        try await goalService.editGoal(newGoal)
    }
    
    func toggleChecklist(_ history: Checklist.History) async throws {
        try await goalService.toggleChecklistHistory(goalId: goal.id, historyId: history.id)
    }
    
    override func bind() {
        let id = goal.id
        goalService.allGoals
            .dropFirst() // 초기값은 버리고 업데이트만 반영
            .compactMap { goals in
                goals.first(where: { goal in goal.id == id })
            }.sink { [weak self] goal in
                self?.goal = goal
            }.store(in: &cancellables)
        
        if !goal.displayHome {
            goalService.allGoals.map { goals in
                let displayCount = goals.filter(\.displayHome).count
                let maximumCount = 3
                return displayCount >= maximumCount
            }
            .sink { [weak self] limited in
                self?.isDisplayLimited = limited
            }.store(in: &cancellables)
        }
    }
    
    func progressOnboardingPhase() {
        switch onboardingPhase {
        case .phase4:
            onboardingPhase = .phase4_1
        case .phase4_1:
            onboardingPhase = .phase5
        case .phase5:
            onboardingPhase = .phase6
        case .phase6:
            onboardingPhase = nil
        case nil:
            break
        }
        
        if onboardingPhase == .phase5 {
            goal.subgoals.append(onboarding5Subgoal)
        }
        
        if onboardingPhase == .phase6 {
            goal.subgoals[0].checklists.append(onboarding6Checklist)
        }
    }
}
