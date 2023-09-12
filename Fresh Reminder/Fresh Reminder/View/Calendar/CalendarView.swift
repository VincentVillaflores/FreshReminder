//
//  CalendarView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

let currDate = getStartOfDay(date: Date.now, calendar: Calendar.current)
let calendar = Calendar.current

struct CalendarView: View {
    @Binding
    var sectionList: [FridgeSection]
    
    @State
    var search = ""
    
    @State
    var selectedDate = getStartOfDay(date: currDate, calendar: calendar)
    
    @State
    var monthOffset = 0
    
    var monthDate: Date { calendar.date(byAdding: .month, value: monthOffset, to: currDate)! }
    
    var monthInt: Int { calendar.component(.month, from: monthDate) }
    
    var dateArray: [DateColor] { generateDateArray(date: monthDate, calendar: calendar) }
    
    var dateSet: Set<Date> {
        var returnSet: Set<Date> = []
        for section in sectionList {
            for item in section.itemList {
                returnSet.insert(item.expirationDate)
            }
        }
        return returnSet
    }
    
    var body: some View {
        
        VStack {
            // Top bar containing month name and arrows
            HStack {
                Text(verbatim: "\(getMonthName(month: monthInt, calendar: calendar)), \(calendar.component(.year, from: monthDate))")
                
                Spacer()
                
                Button {
                    monthOffset -= 1
                } label: {
                    Image(systemName: "chevron.left")
                }.padding([.horizontal])
                
                Button {
                    monthOffset += 1
                } label: {
                    Image(systemName: "chevron.right")
                }
                
            }.padding()
            
            // Main grid of buttons
            CalendarGrid(selectedDate: $selectedDate, monthOffset: $monthOffset, currDate: currDate, dateSet: dateSet, monthInt: monthInt, dateArray: dateArray)
                .padding()
                .animation(.interactiveSpring(), value: monthOffset)
            
            // List of expiring foods
            List {
                if dateSet.contains(selectedDate) {
                    Section("Expiring on \(formatDate(date: selectedDate))") {
                        ForEach($sectionList) { $section in
                            ForEach($section.itemList) { $item in
                                if (item.expirationDate == selectedDate) {
                                    //ItemSheet(item: $item, sectionList: $sectionList, displayDate: false)
                                }
                            }
                        }
                    }
                }
                else {
                    Section("Nothing expiring on \(formatDate(date: selectedDate))"){}
                }
                ListSpacer()
            }
        }
    }
}

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MockCalendarView()
    }
}

struct MockCalendarView: View {
    @State
    var sectionList = loadFridgeItems()
    
    var body: some View {
        CalendarView(sectionList: $sectionList)
    }
}
#endif
