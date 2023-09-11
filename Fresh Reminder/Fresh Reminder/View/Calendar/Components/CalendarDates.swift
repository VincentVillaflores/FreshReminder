//
//  CalendarDates.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 14/8/2023.
//

import Foundation
import SwiftUI

// Utility functions for date manipulation/display
func getMonthName(month: Int, calendar: Calendar) -> String {
    return calendar.monthSymbols[month - 1]
}

func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    return dateFormatter.string(from: date)
}

func getStartOfMonth(date: Date, calendar: Calendar) -> Date {
    let components = calendar.dateComponents([.year, .month], from: date)

    return calendar.date(from: components)!
}

func getStartOfDay(date: Date, calendar: Calendar) -> Date {
    let components = calendar.dateComponents([.year, .month, .day], from: date)

    return calendar.date(from: components)!
}

func daysToSeconds(days: Int) -> Double {
    return 86400 * Double(days)
}

// Function to get dates within a date interval, inclusively
func generateDatesBetween(dateInterval: DateInterval, dateComponents: DateComponents, calendar: Calendar) -> [Date] {
    var datesBetween: [Date] = [dateInterval.start]
    
    calendar.enumerateDates(
        startingAfter: dateInterval.start,
        matching: dateComponents,
        matchingPolicy: .nextTime
    ) { date, _, stop in
        guard let date = date else { return }
        
        guard date < dateInterval.end else {
            stop = true
            return
        }
        
        datesBetween.append(date)
    }
    
    return datesBetween
}

// Function which generates all necessary dates for calendar (end of previous month, all of curr month, start of next month) in a 7-wide grid
func generateDateArray(date: Date, calendar: Calendar) -> [DateColor] {
    
    var result: [DateColor] = []
    
    let NUM_DAYS_IN_WEEK = 7
    let SUNDAY_INDEX = 1
    let startDate = getStartOfMonth(date: date, calendar: calendar)
    
    guard let monthInterval = calendar.dateInterval(of: .month, for: startDate) else { return [] }
    
    // Calculate last month offset to determine how many dates to get from last month
    let startDay = calendar.component(.weekday, from: startDate)
    let offset = startDay - SUNDAY_INDEX
    
    if (offset > 0) {
        let offsetInterval = DateInterval(start: calendar.date(byAdding: .day, value: -offset, to: startDate)!, end: startDate)
        let offsetDatesBetween = generateDatesBetween(dateInterval: offsetInterval, dateComponents: calendar.dateComponents([.hour, .minute, .second], from: offsetInterval.start), calendar: calendar)
        
        for date in offsetDatesBetween {
            result.append(DateColor(date: date, color: .secondary))
        }
    }
    
    // Get all of current month's dates
    let datesBetween = generateDatesBetween(dateInterval: monthInterval, dateComponents: calendar.dateComponents([.hour, .minute, .second], from: monthInterval.start), calendar: calendar)
    
    for date in datesBetween {
        result.append(DateColor(date: date, color: .primary))
    }
    
    // Calculate next month offset to determine how many dates to get from next month
    let nextOffset = result.count % NUM_DAYS_IN_WEEK
    if (nextOffset > 0) {
        let offsetInterval = DateInterval(start: monthInterval.end, end: calendar.date(byAdding: .day, value: NUM_DAYS_IN_WEEK - nextOffset, to: monthInterval.end)!)
        let offsetDatesBetween = generateDatesBetween(dateInterval: offsetInterval, dateComponents: calendar.dateComponents([.hour, .minute, .second], from: offsetInterval.start), calendar: calendar)
        
        for date in offsetDatesBetween {
            result.append(DateColor(date: date, color: .secondary))
        }
    }
    
    return result
    
}

struct DateColor: Identifiable {
    var id = UUID()
    var date: Date
    var color: Color
}
