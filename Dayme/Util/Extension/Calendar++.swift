//
//  Calendar++.swift
//  Dayme
//
//  Created by 정동천 on 12/6/24.
//

import Foundation

extension Calendar {
    
    func weekDates(from date: Date, weekStart: Int = 2) -> [Date] {
        // 1(일) ~ 7(토)
        let weekday = component(.weekday, from: date)
        
        let startOffset = -((weekday - weekStart + 7) % 7)
        let endOffset = startOffset + 6
        
        return (startOffset ... endOffset).compactMap { offset in
            self.date(byAdding: .day, value: offset, to: date)
        }
    }
    
}
