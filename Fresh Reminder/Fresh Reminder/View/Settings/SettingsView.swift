//
//  SettingsView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var cdvm: CoreDataViewModel
    var fruitsVegReminderBinding: Binding<Int> {
        Binding<Int>(
            get: {
                Int(self.cdvm.fruitsVegReminder ?? cdvm.getUser()?.notification?.fruitVegPreference ?? -2)
            },
            set: {
                self.cdvm.fruitsVegReminder = Int32($0)
            }
        )
    }
    var meatReminderBinding: Binding<Int> {
        Binding<Int>(
            get: {
                Int(self.cdvm.meatReminder ?? cdvm.getUser()?.notification?.meatPreference ?? -2)
            },
            set: {
                self.cdvm.meatReminder = Int32($0)
            }
        )
    }
    var seafoodReminderBinding: Binding<Int> {
        Binding<Int>(
            get: {
                Int(self.cdvm.seafoodReminder ?? cdvm.getUser()?.notification?.seafoodPreference ?? -2)
            },
            set: {
                self.cdvm.seafoodReminder = Int32($0)
            }
        )
    }
    var dairyReminderBinding: Binding<Int> {
        Binding<Int>(
            get: {
                Int(self.cdvm.dairyReminder ?? cdvm.getUser()?.notification?.dairyPreference ?? -2)
            },
            set: {
                self.cdvm.dairyReminder = Int32($0)
            }
        )
    }
    var grainReminderBinding: Binding<Int> {
        Binding<Int>(
            get: {
                Int(self.cdvm.grainReminder ?? cdvm.getUser()?.notification?.grainPreference ?? -2)
            },
            set: {
                self.cdvm.grainReminder = Int32($0)
            }
        )
    }
    var miscReminderBinding: Binding<Int> {
        Binding<Int>(
            get: {
                Int(self.cdvm.miscReminder ?? cdvm.getUser()?.notification?.miscPreference ?? -2)
            },
            set: {
                self.cdvm.miscReminder = Int32($0)
            }
        )
    }
    var mixedReminderBinding: Binding<Int> {
        Binding<Int>(
            get: {
                Int(self.cdvm.mixedReminder ?? cdvm.getUser()?.notification?.mixedPreference ?? -2)
            },
            set: {
                self.cdvm.mixedReminder = Int32($0)
            }
        )
    }
    
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
                Stepper("\(ItemCategory.FruitVeg.description): \(self.fruitsVegReminderBinding.wrappedValue)", value: self.fruitsVegReminderBinding, in: reminderRange)
                Stepper("\(ItemCategory.Meat.description): \(self.meatReminderBinding.wrappedValue)", value: self.meatReminderBinding, in: reminderRange)
                Stepper("\(ItemCategory.Seafood.description): \(self.seafoodReminderBinding.wrappedValue)", value: self.seafoodReminderBinding, in: reminderRange)
                Stepper("\(ItemCategory.Dairy.description): \(self.dairyReminderBinding.wrappedValue)", value: self.dairyReminderBinding, in: reminderRange)
                Stepper("\(ItemCategory.Grain.description): \(self.grainReminderBinding.wrappedValue)", value: self.grainReminderBinding, in: reminderRange)
                Stepper("\(ItemCategory.Mixed.description): \(self.mixedReminderBinding.wrappedValue)", value: self.mixedReminderBinding, in: reminderRange)
                Stepper("\(ItemCategory.Misc.description): \(self.miscReminderBinding.wrappedValue)", value: self.miscReminderBinding, in: reminderRange)
            } header: {
                Text("Reminder before expiry (days)")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
