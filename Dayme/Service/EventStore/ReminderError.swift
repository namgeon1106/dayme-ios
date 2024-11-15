//
//  ReminderError.swift
//  Dayme
//
//  Created by 정동천 on 11/15/24.
//

import Foundation

enum ReminderError: LocalizedError {
    case deniedAccessToReminders
    
    var errorDescription: String? {
        switch self {
        case .deniedAccessToReminders:
            "리마인더 접근 권한을 얻지 못했습니다."
        }
    }
}
