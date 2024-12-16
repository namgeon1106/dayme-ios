//
//  Array++.swift
//  Dayme
//
//  Created by 정동천 on 12/15/24.
//

import Foundation

extension Array {
    
    subscript(orNil index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
    
}

extension Array where Element: Equatable, Element: Hashable {
    
    func removeDuplicates() -> [Element] {
        var set: Set<Element> = .init()
        var result: Array<Element> = .init()
        
        for element in self where !set.contains(element) {
            set.insert(element)
            result.append(element)
        }
        
        return result
    }
    
}
