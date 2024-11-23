//
//  LoginCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class LoginCoordinator: Coordinator {
    
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
            
        default:
            break
        }
    }
    
}
