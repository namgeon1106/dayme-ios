//
//  Typography.swift
//  Dayme
//
//  Created by 정동천 on 11/27/24.
//

import UIKit

enum Typo {
    case title24B
    case title20B
    case body20M
    case body18B
    case body16B
    case body16M
    case body16R
    case body14B
    case body14M
    case body14R
    case small12R
}

extension Typo {
    var font: UIFont {
        switch self {
        case .title24B: .pretendard(.bold, 24)
        case .title20B: .pretendard(.bold, 20)
        case .body20M: .pretendard(.medium, 20)
        case .body18B: .pretendard(.bold, 18)
        case .body16B: .pretendard(.bold, 16)
        case .body16M: .pretendard(.medium, 16)
        case .body16R: .pretendard(.regular, 16)
        case .body14B: .pretendard(.bold, 14)
        case .body14M: .pretendard(.medium, 14)
        case .body14R: .pretendard(.regular, 14)
        case .small12R: .pretendard(.regular, 12)
        }
    }
    
    var lineHeight: CGFloat {
        let original = switch self {
        case .title24B: 1.5
        case .title20B: 1.2
        case .body20M: 1.5
        case .body18B: 1.5
        case .body16B: 1.5
        case .body16M: 1.5
        case .body16R: 1.5
        case .body14B: 1.5
        case .body14M: 1.4
        case .body14R: 1.5
        case .small12R: 1.5
        }
        return original / 1.2
    }
}
