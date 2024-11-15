//
//  ReminderService.swift
//  Dayme
//
//  Created by 정동천 on 11/15/24.
//

import UIKit
import EventKit

final class ReminderService {
    
    private let eventStore = EKEventStore()
    
    func write(_ item: ReminderItem, in calendarName: String) async throws {
        let granted = try await eventStore.requestFullAccessToReminders()
        Logger.debug { "리마인더 권한 얻기: \(granted ? "🟢성공" : "🔴실패")" }
        
        if !granted {
            throw ReminderError.deniedAccessToReminders
        }
        
        let existCalendar = getCalendar(for: calendarName)
        let calendar = try existCalendar ?? createCalendar(calendarName, color: .accent)
        let reminder = EKReminder(eventStore: eventStore)
        reminder.calendar = calendar
        reminder.title = item.title
        reminder.notes = item.memo
        
        try eventStore.save(reminder, commit: true)
    }
    
    func fetchAll() async -> [EKReminder] {
        let predicate = eventStore.predicateForReminders(in: nil)
        return await withCheckedContinuation { continuation in
            eventStore.fetchReminders(matching: predicate) { reminders in
                continuation.resume(returning: reminders.orEmpty)
            }
        }
    }
    
    func remove(_ reminder: EKReminder) throws {
        try eventStore.remove(reminder, commit: true)
    }
    
}

private extension ReminderService {
    
    func getCalendar(for name: String) -> EKCalendar? {
        let calendars = eventStore.calendars(for: .reminder)
        return calendars.first(where: { $0.title == name })
    }
    
    func createCalendar(_ title: String, color: UIColor) throws -> EKCalendar {
        let calendar = EKCalendar(for: .reminder, eventStore: eventStore)
        calendar.source = eventStore.defaultCalendarForNewReminders()?.source
        calendar.title = title
        calendar.cgColor = color.cgColor
        
        try eventStore.saveCalendar(calendar, commit: true)
        
        return calendar
    }
    
}
