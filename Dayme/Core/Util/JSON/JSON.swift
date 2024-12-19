//
//  JSON.swift
//  Dayme
//
//  Created by 정동천 on 12/18/24.
//

import Foundation

struct JSON {
    let object: AnyObject?
    
    init(_ object: Any?) {
        self.object = object as? AnyObject
    }
    
    init(_ data: Data?) {
        self.init(data.flatMap { try? JSONSerialization.jsonObject(with: $0) })
    }
    
    init(plist: String) {
        guard let url = Bundle.main.url(forResource: plist, withExtension: "plist") else {
            self.object = nil
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            self.object = try PropertyListSerialization.propertyList(from: data, format: nil) as AnyObject
        } catch {
            Logger.error(error)
            self.object = nil
        }
    }
    
    subscript(index: String) -> JSON {
        (object != nil) ? JSON(dictionary?[index]) : self
    }
    
    subscript(index: Int) -> JSON {
        (object != nil) ? JSON(array?[orNil: index]) : self
    }
    
    var list: [JSON] { self.map({ $0 }) }
}

extension JSON {
    
    var bool: Bool? { object as? Bool }
    var string: String? { object as? String }
    var int: Int? { object as? Int }
    var double: Double? { object as? Double }
    var dictionary: [String: AnyObject]? { object as? [String: AnyObject] }
    var array: [AnyObject]? { object as? [AnyObject] }
    
    var stringJSON: JSON { JSON(string?.data(using: .utf8)) }
    
    var prettryString: String { (object as? [String: Any])?.prettyString ?? "" }
    
    var hasValue: Bool { !(object == nil || object is NSNull) }
    
    func value<T>(_ type: T.Type) -> T? { object as? T }
    func array<E>(_ type: E.Type) -> [E] { array.orEmpty.compactMap { $0 as? E } }
    func dictionary<E>(_ type: E.Type) -> [String: E]? { object as? [String: E] }
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: object ?? [:])
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}

extension JSON: Sequence {
    
    func makeIterator() -> AnyIterator<JSON> {
        guard let array else { return AnyIterator { nil } }
        var index = 0
        return AnyIterator {
            guard let object = array[orNil: index] else { return nil }
            index += 1
            return JSON(object)
        }
    }
    
}
