//
//  CalendarGrid.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 21/8/2023.
//

import SwiftUI

/// A view that represents of the Calendar month the user can use to visualise the proximity of the expiration dates of all their products.
struct CalendarGrid: View {
    @Binding
    var selectedDate: Date
    
    let monthOffset: Int
    
    let currDate = getStartOfDay(date: Date.now, calendar: Calendar.current)
    let dateSet: Set<Date>
    
    var monthDate: Date { Calendar.current.date(byAdding: .month, value: monthOffset, to: currDate)! }
    
    var monthInt: Int { Calendar.current.component(.month, from: monthDate) }
    
    var dateArray: [DateColor] { generateDateArray(date: monthDate, calendar: Calendar.current) }
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack{
            // Column headers
            LazyVGrid(columns: columns) {
                Text("Sun")
                Text("Mon")
                Text("Tue")
                Text("Wed")
                Text("Thu")
                Text("Fri")
                Text("Sat")
            }
            
            Divider().frame(minHeight: 10)
            
            // Grid of day buttons
            LazyVGrid(columns: columns) {
                
                
                ForEach(dateArray, id: \.id) { value in
                    let components = Calendar.current.dateComponents([.day, .month], from: value.date)
                    
                    CalendarButton(
                        selectedDate: $selectedDate,
                        isCurrDate: (currDate == value.date),
                        hasExpiringItems: dateSet.contains(value.date),
                        monthInt: monthInt, components: components,
                        buttonDateColor: value
                    )
                }
            }
        }.padding()
    }
}

/// The user will be able to view all the items that are expiring on the selected day.
struct CalendarButton: View {
    @Binding
    var selectedDate: Date
    
    var isSelected: Bool { selectedDate == buttonDateColor.date }
    
    let isCurrDate: Bool
    let hasExpiringItems: Bool
    let monthInt: Int
    let components: DateComponents
    let buttonDateColor: DateColor
    
    var body: some View {
        ZStack{
            // Current date indicator
            if isCurrDate {
                Circle()
                    .opacity(0.2)
                    .foregroundColor((components.month == monthInt) ? .accentColor : .secondary)
            }
            
            // Circle behind selected date
            Circle()
                .scaleEffect(isSelected ? 1 : 0.001)
                .opacity(isSelected ? 1 : 0)
                .animation(.interactiveSpring(response: 0.2, dampingFraction: 0.6), value: isSelected)
                .foregroundColor((components.month == monthInt) ? .accentColor : .secondary)
            
            // Day number as button
            Button {
                if (components.month != monthInt) {
                    //monthOffset += components.month! - monthInt
                }
                
                if (buttonDateColor.date == selectedDate) {
                    return
                }
                
                selectedDate = buttonDateColor.date
            } label: {
                Text("\(components.day!)")
                    .foregroundColor(isSelected ? .white : buttonDateColor.color)
                    .padding(.vertical)
            }
            
            // Badge showing on days with expiring items
            if hasExpiringItems {
                Circle()
                    .scale(0.15)
                    .offset(x: 12, y: -12)
                    .foregroundColor((components.month == monthInt) ? .accentColor : .secondary)
            }
        }
    }
}

#if DEBUG
struct CalendarGrid_Previews: PreviewProvider {
    static var previews: some View {
        MockCalendarGrid()
    }
}

struct MockCalendarGrid: View {
    let persistenceController = PersistenceController.shared
    @StateObject private var cdvm: CoreDataViewModel
    init(){
        let context = persistenceController.container.viewContext
        _cdvm = StateObject(wrappedValue: CoreDataViewModel(context: context))
        cdvm.setUp()
    }
    
    @State
    var selectedDate = getStartOfDay(date: Date.now, calendar: Calendar.current)
    
    @State
    var monthOffset = 0
    
    var monthDate: Date { Calendar.current.date(byAdding: .month, value: monthOffset, to: Date.now)! }
    
    var monthInt: Int { Calendar.current.component(.month, from: monthDate) }
    
    var dateArray: [DateColor] { generateDateArray(date: monthDate, calendar: Calendar.current) }
    
    var dateSet: Set<Date> {
        return cdvm.uniqueDates()
    }
    
    var body: some View {
        CalendarGrid(selectedDate: $selectedDate, monthOffset: monthOffset, dateSet: dateSet)
    }
}
#endif
