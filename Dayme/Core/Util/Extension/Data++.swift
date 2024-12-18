//
//  Data++.swift
//  Dayme
//
//  Created by 정동천 on 11/20/24.
//

import Foundation

extension Data {
    
    var prettyString: String? {
        let jsonObject = try? JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed)
        
        if let jsonDict = jsonObject as? [String: Any] {
            return jsonDict.prettyString
        } else if let jsonArray = jsonObject as? [[String: Any]] {
            return jsonArray.compactMap(\.prettyString).joined(separator: ",\n")
        }
        
        return nil
    }
    
}
