//
//  OnboardingCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        let loginVC = LoginVC()
        loginVC.coordinator = self
        
        if animated {
            addFadeTransaction(in: nav.view.layer)
        }
        
        nav.viewControllers = [loginVC]
    }
    
    override func trigger(with event: FlowEvent) {
        switch event {
        case .loginFinished, .signupFinished:
            parent?.trigger(with: event)
            
        case .signupNeeded:
            pushTermsScreen()
            
        case .signupCanceled:
            popViewController(animated: true)
            
        default:
            break
        }
    }
    
}

// MARK: - Navigate

private extension OnboardingCoordinator {
    
    func pushTermsScreen() {
        let termsVC = TermsVC()
        termsVC.coordinator = self
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(termsVC, animated: true)
    }
    
}
