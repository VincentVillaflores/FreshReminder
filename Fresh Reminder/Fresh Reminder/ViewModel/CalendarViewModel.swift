//
//  CalendarViewModel.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 13/10/2023.
//

import Foundation

/// ViewModel class to act as the single source of truth for the calendar's current state, and to have sole responsibility for its mutation
class CalendarViewModel: ObservableObject {
    /// Variable representing the date currently selected
    @Published
    var selectedDate = getStartOfDay(date: Date.now, calendar: Calendar.current)
    
    /// Variable representing the current month for the displayed calendar (relative to the current month)
    @Published
    var monthOffset = 0
    
    /// Function to change the selected date to the provided date
    ///
    /// - Parameter date: The category to set selected date to.
    func selectDate(date: Date) {
        self.selectedDate = date
    }
    
    /// Function to reduce month offset by one, changing the Calendar to the previous month's
    func nextMonth() {
        self.monthOffset += 1
    }
    
    /// Function to reduce month offset by one, changing the Calendar to the previous month's
    func prevMonth() {
        self.monthOffset -= 1
    }
}
