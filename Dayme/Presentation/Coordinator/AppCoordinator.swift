//
//  AppCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        let isAuthorized = Keychain.read(key: Env.Keychain.accessTokenKey) != nil
        
        if isAuthorized {
            startMainFlow(animated: false)
        } else {
            startLoginFlow(animated: false)
        }
    }
    
    override func trigger(with event: FlowEvent) {
        switch event {
        case .loginFinished, .signupFinished:
            children.removeAll()
            startMainFlow(animated: true)
            
        case .logout:
            children.removeAll()
            startLoginFlow(animated: true)
            
        default:
            break
        }
    }
    
}

private extension AppCoordinator {
    
    func startMainFlow(animated: Bool) {
        let child = MainCoordinator(nav: nav)
        startFlow(child, animated: animated)
    }
    
    func startLoginFlow(animated: Bool) {
        let child = LoginCoordinator(nav: nav)
        startFlow(child, animated: animated)
    }
    
}
