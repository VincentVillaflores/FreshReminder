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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(
                UserSettings(reminderFV: 1, reminderMeat: 1, reminderSeafood: 1, reminderDairy: 1, reminderGrain: 1, reminderMixed: 1, reminderMisc: 1)
            )
    }
}
