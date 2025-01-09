//
//  AppCoordinator.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    override func start(animated: Bool) {
        let accessToken = Keychain.read(key: Env.Keychain.accessTokenKey)
        let isAuthorized = accessToken != nil
        
        // 앱 삭제시 키체인은 삭제가 안 되기 때문에 이중 검증
        if UserDefault.loggedIn, isAuthorized {
            Logger.debug { "ACCESS TOKEN\n\(accessToken.orEmpty)" }
            Logger.debug { "REFRESH TOKEN\n\(Keychain.read(key: Env.Keychain.refreshTokenKey).orEmpty)" }
            
            let splashVC = SplashVC()
            splashVC.coordinator = self
            nav.viewControllers = [splashVC]
        } else {
            startLoginFlow(animated: false)
        }
    }
    
    override func trigger(with event: FlowEvent) {
        switch event {
        case .loginFinished, .signupFinished:
            children.removeAll()
            startMainFlow(animated: true)
            
        case .logout, .userDeleted:
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
