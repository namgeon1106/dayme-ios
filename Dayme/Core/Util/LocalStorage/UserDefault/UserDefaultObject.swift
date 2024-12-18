//
//  UserDefaultObject.swift
//  Dayme
//
//  Created by 정동천 on 12/1/24.
//

import Foundation

@propertyWrapper
struct UserDefaultPrimitive<T> {
    let key: UserDefaultKey
    let defaultValue: T?
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    init(key: UserDefaultKey, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            let value = userDefaults.object(forKey: key.path) as? T
            return value ?? defaultValue
        }
        
        set {
            userDefaults.set(newValue, forKey: key.path)
            userDefaults.synchronize()
        }
    }
}

@propertyWrapper
struct UserDefaultCodable<T: Codable> {
    let key: UserDefaultKey
    let defaultValue: T?
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    init(key: UserDefaultKey, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            if let data = userDefaults.object(forKey: key.path) as? Data,
               let value = try? JSONDecoder().decode(T.self, from: data) {
                return value
            }
            
            return defaultValue
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            
            userDefaults.set(data, forKey: key.path)
            userDefaults.synchronize()
        }
    }
}
