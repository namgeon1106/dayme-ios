//
//  NotificationService.swift
//  Dayme
//
//  Created by 정동천 on 11/30/24.
//

import UIKit
import FirebaseMessaging
import UserNotifications

final class NotificationService: NSObject {
    
    static let shared = NotificationService()
    
    private var messaging: Messaging!
    private var notiCenter: UNUserNotificationCenter!
    
    
    func configure() {
        messaging = .messaging()
        notiCenter = .current()
        messaging.delegate = self
        notiCenter.delegate = self
    }
    
    @MainActor
    @discardableResult
    func requestAuthorization() async throws -> Bool {
        let options: UNAuthorizationOptions = [.sound, .alert, .badge]
        let granted = try await notiCenter.requestAuthorization(options: options)
        
        if granted {
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        return granted
    }
    
    func registerDeviceToken(_ deviceToken: Data) {
        messaging.apnsToken = deviceToken
    }
    
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    
    @MainActor
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo as NSDictionary
        Logger.debug { "\(userInfo)" }
    }
    
    @MainActor
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner, .list]
    }
    
}

// MARK: - MessagingDelegate

extension NotificationService: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Logger.debug { "FCM TOKEN RECEIVED\n\(fcmToken.orEmpty)" }
    }
    
}
