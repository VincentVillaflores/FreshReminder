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
    @StateObject private var cdvm: CoreDataViewModel
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init(){
        let context = persistenceController.container.viewContext
        _cdvm = StateObject(wrappedValue: CoreDataViewModel(context: context))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cdvm)
        }
    }
}
