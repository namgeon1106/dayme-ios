//
//  AppDelegate.swift
//  Dayme
//
//  Created by 정동천 on 10/31/24.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let noticationService: NotificationService = .shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        noticationService.configure()
        Analytics.logEvent("start", parameters: nil)
        UserDefault.visitCount += 1
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        noticationService.registerDeviceToken(deviceToken)
    }
    
}
