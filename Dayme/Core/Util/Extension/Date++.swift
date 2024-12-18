//
//  Date++.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import Foundation

extension Date {
    
    func string(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func isToday() -> Bool {
        isSameDay(with: Date())
    }
    
    func isSameDay(with date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: self)
    }
    
    func isSunday() -> Bool {
        Calendar.current.component(.weekday, from: self) == 1
    }
    
    func addingDays(_ offset: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: offset, to: self)!
    }
    
    static func string(_ string: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
    
}
