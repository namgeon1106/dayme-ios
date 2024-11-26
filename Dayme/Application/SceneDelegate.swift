//
//  SceneDelegate.swift
//  Dayme
//
//  Created by 정동천 on 10/31/24.
//

import UIKit
import GoogleSignIn
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let nav = UINavigationController()
        nav.setNavigationBarHidden(true, animated: false)
        
        appCoordinator = AppCoordinator(nav: nav)
        appCoordinator?.start(animated: false)
        
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = appCoordinator?.nav
            window?.tintColor = .colorMain1
            window?.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        } else {
            GIDSignIn.sharedInstance.handle(url)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}
