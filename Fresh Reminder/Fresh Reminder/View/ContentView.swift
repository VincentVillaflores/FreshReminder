//
//  ContentView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

struct ContentView: View {
    @State
    var sectionList = loadFridgeItems()
    
    var body: some View {
        TabView {
            FridgeView(sectionList: $sectionList)
                .tabItem {
                    Label("Fridge", systemImage: "refrigerator.fill")
                }
            CalendarView(sectionList: $sectionList)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MockContentView()
    }
}

struct MockContentView: View {
    let persistenceController = PersistenceController.shared
    @StateObject private var cdvm: CoreDataViewModel
    init(){
        let context = persistenceController.container.viewContext
        _cdvm = StateObject(wrappedValue: CoreDataViewModel(context: context))
        cdvm.setUp()
    }
    
    @State
    var sectionList = loadFridgeItems()
    
    var body: some View {
        ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(cdvm)
            .environmentObject(
                UserSettings(reminderFV: 1, reminderMeat: 1, reminderSeafood: 1, reminderDairy: 1, reminderGrain: 1, reminderMixed: 1, reminderMisc: 1)
            )
    }
}
#endif
