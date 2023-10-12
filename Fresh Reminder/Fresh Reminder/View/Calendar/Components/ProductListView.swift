//
//  ProductListView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 13/10/2023.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var cdvm: CoreDataViewModel
    
    @Binding
    var selectedDate: Date
    
    var expiringProducts: [Product] { cdvm.getProductsExpiringOn(date: selectedDate) }
    
    var body: some View {
        List {
            let expiringProducts: [Product] = cdvm.getProductsExpiringOn(date: selectedDate)
            if !expiringProducts.isEmpty {
                Section("Expiring on \(formatDate(date: selectedDate))") {
                    ForEach(expiringProducts) { item in
                        ItemSheet(item: Binding.constant(item), displayDate: false)
                    }
                }
            }
            else {
                Section("Nothing expiring on \(formatDate(date: selectedDate))"){}
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
        ProductListView(selectedDate: $selectedDate)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(cdvm)
    }
}
#endif
