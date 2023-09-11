//
//  SettingsView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var userSettings: UserSettings
    
    let reminderRange = 1...31
    
    var body: some View {
        Form {
            Section{} header: {
                Text(verbatim: "Settings")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }.textCase(nil)
            
            // Steppers to alter the environment object storing user settings
            Section {
                Stepper("\(ItemCategory.FruitVeg.description): \(userSettings.reminderFV)", value: $userSettings.reminderFV, in: reminderRange)
                Stepper("\(ItemCategory.Meat.description): \(userSettings.reminderMeat)", value: $userSettings.reminderMeat, in: reminderRange)
                Stepper("\(ItemCategory.Seafood.description): \(userSettings.reminderSeafood)", value: $userSettings.reminderSeafood, in: reminderRange)
                Stepper("\(ItemCategory.Dairy.description): \(userSettings.reminderDairy)", value: $userSettings.reminderDairy, in: reminderRange)
                Stepper("\(ItemCategory.Grain.description): \(userSettings.reminderGrain)", value: $userSettings.reminderGrain, in: reminderRange)
                Stepper("\(ItemCategory.Mixed.description): \(userSettings.reminderMixed)", value: $userSettings.reminderMixed, in: reminderRange)
                Stepper("\(ItemCategory.Misc.description): \(userSettings.reminderMisc)", value: $userSettings.reminderMisc, in: reminderRange)
            } header: {
                Text("Reminder before expiry (days)")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(
                UserSettings(reminderFV: 1, reminderMeat: 1, reminderSeafood: 1, reminderDairy: 1, reminderGrain: 1, reminderMixed: 1, reminderMisc: 1)
            )
    }
}
