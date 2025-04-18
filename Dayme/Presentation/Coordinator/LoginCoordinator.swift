//
//  OnboardingCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class LoginCoordinator: Coordinator {
    
    private var oAuthSignupInfo: OAuthSignupInfo?
    
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
        case .loginFinished:
            parent?.trigger(with: event)
            
        case .signupNeeded(let info):
            self.oAuthSignupInfo = info
            pushTermsScreen()
            
        case .termsNeeded(let terms):
            pushTermsDetailScreen(terms)
            
        case .nicknameNeeded:
            pushNicknameScreen()
            
        case .signupFinished:
            popToRootViewController(animated: true)
            
        case .signupCanceled, .termsCanceled, .nicknameCanceled:
            popViewController(animated: true)
            
        default:
            break
        }
    }
    
}

// MARK: - Navigate

private extension LoginCoordinator {
    
    func pushTermsScreen() {
        let termsVC = TermsVC()
        termsVC.coordinator = self
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(termsVC, animated: true)
    }
    
    func pushTermsDetailScreen(_ terms: Terms) {
        let termsDetailVC = TermsDetailVC(terms: terms)
        termsDetailVC.coordinator = self
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(termsDetailVC, animated: true)
    }
    
    func pushNicknameScreen() {
        guard let oAuthSignupInfo else {
            Logger.error { "empty OAuthSignupInfo" }
            return
        }
        
        let nicknameVC = NicknameVC(authInfo: oAuthSignupInfo)
        nicknameVC.coordinator = self
        nav.interactivePopGestureRecognizer?.delegate = self
        nav.pushViewController(nicknameVC, animated: true)
    }
    
}
