//
//  Dictionary++.swift
//  Dayme
//
//  Created by 정동천 on 11/20/24.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    
    var prettyString: String? {
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return data.flatMap { String(data: $0, encoding: .utf8) }
    }
    
}
