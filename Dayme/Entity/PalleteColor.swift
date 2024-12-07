//
//  PalleteColor.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import Foundation

enum PalleteColor: CaseIterable {
    
    case c1, c2, c3, c4, c5
    
    var hex: String {
        switch self {
        case .c1: "#FF0000"
        case .c2: "#9747FF"
        case .c3: "#00EF89"
        case .c4: "#E843E5"
        case .c5: "#18E5FA"
        }
    }
    
}
