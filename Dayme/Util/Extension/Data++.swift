//
//  Data++.swift
//  Dayme
//
//  Created by 정동천 on 11/20/24.
//

import Foundation

extension Data {
    
    var prettyString: String? {
        let json = try? JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed) as? [String: Any]
        return json?.prettyString
    }
    
}
