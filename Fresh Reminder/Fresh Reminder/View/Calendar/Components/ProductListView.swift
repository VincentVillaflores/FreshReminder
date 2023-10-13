//
//  ProductListView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 13/10/2023.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var cdvm: CoreDataViewModel
    
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    
    var expiringProducts: [Product] { cdvm.getProductsExpiringOn(date: calendarViewModel.selectedDate) }
    
    var body: some View {
        List {
            if !expiringProducts.isEmpty {
                Section("Expiring on \(formatDate(date: calendarViewModel.selectedDate))") {
                    ForEach(expiringProducts) { item in
                        ItemSheet(item: Binding.constant(item), displayDate: false)
                    }
                }
            }
            else {
                Section("Nothing expiring on \(formatDate(date: calendarViewModel.selectedDate))"){}
            }
        }
    }
}

#if DEBUG
#Preview {
    MockProductListView()
}

struct MockProductListView: View {
    let persistenceController = PersistenceController.shared
    @StateObject private var cdvm: CoreDataViewModel
    init(){
        let context = persistenceController.container.viewContext
        _cdvm = StateObject(wrappedValue: CoreDataViewModel(context: context))
        cdvm.setUp()
    }
    
    @State
    var selectedDate = getStartOfDay(date: Date.now, calendar: Calendar.current)
    
    var body: some View {
        ProductListView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(cdvm)
            .environmentObject(CalendarViewModel())
    }
}
#endif
