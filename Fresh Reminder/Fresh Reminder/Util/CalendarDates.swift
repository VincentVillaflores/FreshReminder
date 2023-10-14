//
//  CalendarDates.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 14/8/2023.
//

import Foundation
import SwiftUI

// Utility functions for date manipulation/display
/// Retrieves the name of the month based on its numerical representation.
///
/// This function provides the textual name of a month (e.g., "January", "February") given its
/// numerical representation (`month`). The month's numbering starts from 1 (for January) up to 12 (for December).
///
/// - Parameters:
///   - month: The numerical representation of the month (from 1 to 12).
///   - calendar: The `Calendar` object used to retrieve the month symbols.
///
/// - Returns: The textual name of the month or an empty string if the month number is out of bounds.
func getMonthName(month: Int, calendar: Calendar) -> String {
    return calendar.monthSymbols[month - 1]
}

func getMonthAndYear(monthOffset: Int) -> String {
    let calendar = Calendar.current
    guard let monthDate = calendar.date(byAdding: .month, value: monthOffset, to: Date.now) else {
        return "Unknown date"
    }
    
    let month = calendar.component(.month, from: monthDate)
    
    let year = calendar.component(.year, from: monthDate)
    
    return "\(calendar.monthSymbols[month - 1]), \(year)"
}

/// Formats the given date into a string representation "dd/MM/yyyy".
///
/// This function takes a `Date` object as an input and returns its string representation
/// in the format of "dd/MM/yyyy".
///
/// - Parameter date: The date to be formatted.
///
/// - Returns: A string representation of the input date in "dd/MM/yyyy" format.
func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    return dateFormatter.string(from: date)
}


/// Returns the start date (usually the first day) of the month for a given date.
///
/// This function calculates the start date of the month (typically the first day)
/// for a given date. It is useful when you need to determine the starting boundary
/// for monthly calculations or operations.
///
/// - Parameters:
///   - date: The date from which the month's start date should be determined.
///   - calendar: The calendar system being used to make the calculation.
///
/// - Returns: A date representing the start of the month for the given date.
func getStartOfMonth(date: Date, calendar: Calendar) -> Date {
    let components = calendar.dateComponents([.year, .month], from: date)

    return calendar.date(from: components)!
}

/// Returns the start time (usually midnight) of a given date.
///
/// This function calculates the start time of the day (typically midnight)
/// for a given date. It is beneficial when you need to determine the starting
/// boundary for daily calculations or operations.
///
/// - Parameters:
///   - date: The date from which the day's start time should be determined.
///   - calendar: The calendar system being used to make the calculation.
///
/// - Returns: A date representing the start time (usually midnight) of the day for the given date.
func getStartOfDay(date: Date, calendar: Calendar) -> Date {
    let components = calendar.dateComponents([.year, .month, .day], from: date)

    return calendar.date(from: components)!
}

/// Converts a given number of days into its equivalent value in seconds.
///
/// This function aids in time-based calculations by converting days into seconds.
/// It assumes that each day has 86,400 seconds (24 hours * 60 minutes * 60 seconds).
///
/// - Parameter days: The number of days that should be converted into seconds.
///
/// - Returns: A double representing the total number of seconds for the given days.
func daysToSeconds(days: Int) -> Double {
    return 86400 * Double(days)
}

// Function to get dates within a date interval, inclusively
/// Generates an array of dates between two specified dates at intervals determined by the provided date components.
///
/// This function returns an array of dates starting from the beginning of the specified date interval and continuing at intervals determined by the date components, until the end of the date interval is reached.
///
/// - Parameters:
///   - dateInterval: The range between which dates should be generated, including the start date but excluding the end date.
///   - dateComponents: The components defining the intervals at which dates should be generated.
///   - calendar: The calendar context for the date operations.
///
/// - Returns: An array of `Date` objects generated between the specified interval at the intervals defined by the date components.
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
/// Generates an array of `DateColor` objects for the entire month of the specified date.
///
/// This function returns an array of `DateColor` objects that represents each day of the specified month, including offset dates from the previous and next months to fill up the entire week. For instance, if a month starts on a Wednesday, it will include dates from the last month for Sunday, Monday, and Tuesday. Similarly, if a month ends on a Thursday, it will include dates from the next month for Friday, Saturday, and Sunday. Offset dates are marked with a secondary color, while dates from the specified month are marked with a primary color.
///
/// - Parameters:
///   - date: A date within the month for which the array should be generated.
///   - calendar: The calendar context for the date operations.
///
/// - Returns: An array of `DateColor` objects representing each day of the month, including offsets from the previous and next months.
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

/// Represents a date with an associated color.
///
/// The `DateColor` struct provides a convenient way to represent a date along with a visual hint (color) that can be used, for instance, in a calendar UI to differentiate between dates from the current month and offsets from the previous or next months.
///
/// - Properties:
///   - id: A unique identifier for each instance of `DateColor`.
///   - date: The specific date that the struct represents.
///   - color: A visual representation or hint associated with the date.
struct DateColor: Identifiable {
    var id = UUID()
    var date: Date
    var color: Color
}
