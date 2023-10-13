//
//  CalendarViewModel.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 13/10/2023.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published
    var selectedDate = getStartOfDay(date: Date.now, calendar: Calendar.current)
    
    @Published
    var monthOffset = 0
    
    func selectDate(date: Date) {
        self.selectedDate = date
    }
    
    func nextMonth() {
        self.monthOffset += 1
    }
    
    func prevMonth() {
        self.monthOffset -= 1
    }
}
