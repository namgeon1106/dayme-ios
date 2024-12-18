//
//  Haptic.swift
//  Dayme
//
//  Created by 정동천 on 11/23/24.
//

import UIKit

enum Haptic {
    
    static func noti(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }
    
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
}
