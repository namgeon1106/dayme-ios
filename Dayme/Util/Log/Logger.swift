//
//  Logger.swift
//  Dayme
//
//  Created by 정동천 on 11/7/24.
//

import Foundation
import OSLog

fileprivate extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let error = OSLog(subsystem: subsystem, category: "Error")
    static let network = OSLog(subsystem: subsystem, category: "Network")
}

enum Logger {
    static func debug(_ message: String) {
        debug { message }
    }
    
    static func error(_ message: String) {
        debug { message }
    }
    
    static func network(_ message: String) {
        debug { message }
    }
    
    static func debug(_ message: () -> String) {
#if DEBUG
        os_log("%@", log: .debug, type: .debug, "🐛 \(message())")
#endif
    }
    
    static func error(_ message: () -> String) {
#if DEBUG
        os_log("%@", log: .error, type: .error, "🚨 \(message())")
#endif
    }
    
    static func network(_ message: () -> String) {
#if DEBUG
        os_log("%@", log: .network, type: .default, "🤖 \(message())")
#endif
    }
}
