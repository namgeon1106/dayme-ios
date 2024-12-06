//
//  DateFormatStyle.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import Foundation

enum DateFormatStyle: String {
    /// yyyy
    case year = "yyyy"
    /// M
    case month = "M"
    /// d
    case day = "d"
    /// EEE
    case weekday = "EEE"
    
    
    var format: String { rawValue }
}

extension Date {
    
    func string(style: DateFormatStyle) -> String {
        string(format: style.format)
    }
    
}
