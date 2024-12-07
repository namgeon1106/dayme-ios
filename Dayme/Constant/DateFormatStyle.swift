//
//  DateFormatStyle.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import Foundation

enum DateFormatStyle: String {
    /// yyyy-MM-dd
    case api = "yyyy-MM-dd"
    /// yyyy
    case year = "yyyy"
    /// M
    case month = "M"
    /// d
    case day = "d"
    /// EEE
    case weekday = "EEE"
    
    case goalDuration = "M월 d일 (EEE)"
    
    
    var format: String { rawValue }
}

extension Date {
    
    func string(style: DateFormatStyle) -> String {
        string(format: style.format)
    }
    
    static func string(_ string: String, style: DateFormatStyle) -> Date? {
        Date.string(string, format: style.format)
    }
    
}
