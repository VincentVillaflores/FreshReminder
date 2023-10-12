//
//  CalendarView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 12/10/2023.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var cdvm: CoreDataViewModel
    
    @State
    var selectedDate = getStartOfDay(date: Date.now, calendar: Calendar.current)
    
    @State
    var monthOffset = 0
    
    var dateSet: Set<Date> {
        return cdvm.uniqueDates()
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text(verbatim: getMonthAndYear(monthOffset: monthOffset))
                
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
            
            CalendarViewController(dateSet: dateSet, monthOffset: $monthOffset, selectedDate: $selectedDate).frame(minHeight: 400)
            
            ProductListView(selectedDate: $selectedDate)
            
        }
    }
}



#if DEBUG
#Preview {
    MockCalendarView()
}

struct MockCalendarView: View {
    let persistenceController = PersistenceController.shared
    @StateObject private var cdvm: CoreDataViewModel
    init(){
        let context = persistenceController.container.viewContext
        _cdvm = StateObject(wrappedValue: CoreDataViewModel(context: context))
        cdvm.setUp()
    }
    
    var body: some View {
        CalendarView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(cdvm)
    }
}
#endif
