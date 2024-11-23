//
//  AppCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    override func start() {
        let isAuthorized = Keychain.read(key: Env.Keychain.accessTokenKey) != nil
        
        if isAuthorized {
            startMainFlow()
        } else {
            startLoginFlow()
        }
    }
    
    override func trigger(with event: FlowEvent) {
        switch event {
        case .loginFinished, .signupFinished:
            children.removeAll()
            startMainFlow()
            
        case .logout:
            children.removeAll()
            startLoginFlow()
            
        default:
            break
        }
    }
    
}

private extension AppCoordinator {
    
    func startMainFlow() {
        let child = MainCoordinator(nav: nav)
        startFlow(child)
    }
    
    func startLoginFlow() {
        let child = LoginCoordinator(nav: nav)
        startFlow(child)
    }
    
}
