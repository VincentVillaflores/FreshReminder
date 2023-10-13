//
//  CalendarView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 12/10/2023.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var cdvm: CoreDataViewModel
    
    @StateObject
    var calendarViewModel = CalendarViewModel()
    
    var body: some View {
        
        VStack {
            HStack {
                Text(verbatim: getMonthAndYear(monthOffset: calendarViewModel.monthOffset))
                
                Spacer()
                
                Button {
                    calendarViewModel.prevMonth()
                } label: {
                    Image(systemName: "chevron.left")
                }.padding([.horizontal])
                
                Button {
                    calendarViewModel.nextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                }
                
            }.padding()
            
            CalendarViewController().frame(minHeight: 400)
            
            ProductListView()
            
        }.environmentObject(calendarViewModel)
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
