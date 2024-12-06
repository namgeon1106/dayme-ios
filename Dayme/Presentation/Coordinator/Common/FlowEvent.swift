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
    case goalEditNeeded
    case goalEditCanceled
    
    // MARK: Setting
    case logout
    case userDeleted
}
