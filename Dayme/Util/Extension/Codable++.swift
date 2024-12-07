//
//  Codable++.swift
//  Dayme
//
//  Created by 정동천 on 12/7/24.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        let object = try? JSONSerialization.jsonObject(with: data)
        return object as? [String: Any]
    }
}
