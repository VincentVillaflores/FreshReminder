//
//  Fresh_ReminderApp.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

@main
struct Fresh_ReminderApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(
                    UserSettings(reminderFV: 1, reminderMeat: 1, reminderSeafood: 1, reminderDairy: 1, reminderGrain: 1, reminderMixed: 1, reminderMisc: 1)
                )
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
