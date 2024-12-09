//
//  DateFormatStyle.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import Foundation

enum DateFormatStyle {
    /// yyyy-MM-dd
    case standard
    /// yyyy.MM.dd.
    case dotted
    /// yyyy
    case year
    /// M
    case month
    /// d
    case day
    /// EEE
    case weekday
    /// yyyy.MM.dd (EEE)
    case goalDuration
    
    
    var format: String {
        switch self {
        case .standard: "yyyy-MM-dd"
        case .dotted: "yyyy.MM.dd."
        case .year: "yyyy"
        case .month: "M"
        case .day: "d"
        case .weekday: "EEE"
        case .goalDuration: "yyyy.MM.dd (EEE)"
        }
    }
}

extension Date {
    
    func string(style: DateFormatStyle) -> String {
        string(format: style.format)
    }
    
    static func string(_ string: String, style: DateFormatStyle) -> Date? {
        Date.string(string, format: style.format)
    }
    
}
