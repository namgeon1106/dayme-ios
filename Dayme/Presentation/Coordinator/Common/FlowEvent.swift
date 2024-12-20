//
//  FlowEvent.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import Foundation

enum FlowEvent {
    
    // MARK: Onboarding
    case loginFinished
    case signupNeeded(OAuthSignupInfo)
    case signupCanceled
    case termsNeeded(Terms)
    case termsCanceled
    case nicknameNeeded
    case nicknameCanceled
    case signupFinished
    
    // MARK: Goal
    case goalAddNeeded
    case goalAddCanceled
    case goalEditNeeded(Goal)
    case goalEditCanceled
    case goalDetailNeeded(Goal)
    case goalDetailCanceled
    
    // MARK: Subgoal
    case subgoalAddNeeded(Goal)
    case subgoalAddCanceled
    case subgoalEditNeeded(goal: Goal, subgoal: Subgoal)
    case subgoalEditCanceled
    
    // MARK: Checklist
    case checklistAddNeeded(goal: Goal, subgoal: Subgoal?)
    case checklistAddCanceled
    case checklistEditNeeded(goal: Goal, subgoal: Subgoal?, checklist: Checklist)
    case checklistEditCanceled
    
    // MARK: Setting
    case logout
    case userDeleted
    
}
