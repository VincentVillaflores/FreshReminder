//
//  UserSettings.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 27/8/2023.
//

import Foundation
import SwiftUI

// Settings object, containing the days before expiry that the user wishes to be reminded
class UserSettings: ObservableObject {
    internal init(reminderFV: Int, reminderMeat: Int, reminderSeafood: Int, reminderDairy: Int, reminderGrain: Int, reminderMixed: Int, reminderMisc: Int) {
        self.reminderFV = reminderFV
        self.reminderMeat = reminderMeat
        self.reminderSeafood = reminderSeafood
        self.reminderDairy = reminderDairy
        self.reminderGrain = reminderGrain
        self.reminderMixed = reminderMixed
        self.reminderMisc = reminderMisc
    }
    
    @Published var reminderFV: Int
    @Published var reminderMeat: Int
    @Published var reminderSeafood: Int
    @Published var reminderDairy: Int
    @Published var reminderGrain: Int
    @Published var reminderMixed: Int
    @Published var reminderMisc: Int

    
}
