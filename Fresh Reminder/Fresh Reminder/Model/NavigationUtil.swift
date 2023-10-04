//
//  NavigationUtil.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 23/9/2023.
//

import Foundation

// Simple enum to keep track of non data-driven routes
/// Enumerates possible navigation destinations in the application.
///
/// This enumeration provides a list of view destinations that can be navigated to. It can be used to determine which view to present or navigate to based on user actions or other app events.
///
/// - `searchItem`: Represents the destination for searching items.
/// - `photoItem`: Represents the destination for viewing or managing photo items.
enum Destinations {
    case searchItem
    case photoItem
}
