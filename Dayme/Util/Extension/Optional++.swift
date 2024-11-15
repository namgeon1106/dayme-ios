//
//  Optional++.swift
//  Dayme
//
//  Created by 정동천 on 11/15/24.
//

import Foundation

extension Optional where Wrapped: Emptyable {
    var orEmpty: Wrapped { self ?? Wrapped() }
}

// MARK: - Emptyable

/// 빈 값을 가질 수 있는 타입
protocol Emptyable {
    init()
}

extension String: Emptyable {}
extension Data: Emptyable {}
extension Array: Emptyable {}
extension Dictionary: Emptyable {}
extension Set: Emptyable {}
extension NSObject: Emptyable {}
