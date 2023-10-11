//
//  AppDelegate.swift
//  Fresh Reminder
//
//  Created by Vincent Villaflores on 9/10/2023.
//

import UserNotifications
import UIKit

/// `AppDelegate` serves as the main delegate for the application, primarily handling the launching process and
/// notifications permission.
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    /// Invoked when the application finishes launching. Configures the initial application settings
    /// and requests the user's permission for notifications.
    /// - Parameters:
    ///   - application: Central control for interactions with the operating system.
    ///   - launchOptions: A dictionary indicating the reason the app was launched (if any).
    /// - Returns: A boolean value indicating the successful completion of the launch.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Ask permission for notifications
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied\n")
            }
        }
        
        return true
    }
}

/// Schedules a notification for an expiring product.
/// - Parameters:
///   - productName: The name of the product expiring.
///   - productID: The unique identifier of the product.
///   - expirationDate: The date when the product is set to expire.
///   - numOfDays: The number of days before the expiration date the user should be notified.
func addNotification(productName: String, productID: UUID, expirationDate: Date, numOfDays: Int32){
    let center = UNUserNotificationCenter.current()
    
    let content = UNMutableNotificationContent()
    content.title = "Food Expiring Soon!"
    content.body = "\(productName) is expiring in \(numOfDays) days"
    content.sound = UNNotificationSound.default
    content.categoryIdentifier = "Expiry"
    
    // Setup trigger time
    let calendar = Calendar.current
    guard let notificationDate = calendar.date(byAdding: .day, value: -Int(numOfDays), to: expirationDate) else { return }
    let dateComponents = calendar.dateComponents([.day, .month, .year], from: notificationDate)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    // Create request
    let uniqueID = productID.uuidString // Keep a record of this if necessary
    let request = UNNotificationRequest(identifier: uniqueID, content: content, trigger: trigger)
    center.add(request) // Add the notification request
}

/// Removes a previously scheduled notification.
/// - Parameter productID: The unique identifier of the product whose notification should be removed.
func removeNotification(productID: UUID) {
    let center = UNUserNotificationCenter.current()
    let notifUUID = productID.uuidString
    
    center.removePendingNotificationRequests(withIdentifiers: [notifUUID])
}

/// Updates an existing notification, removing the old one and adding a new updated one.
/// - Parameters:
///   - productName: The name of the product expiring.
///   - productID: The unique identifier of the product.
///   - expirationDate: The date when the product is set to expire.
///   - numOfDays: The number of days before the expiration date the user should be notified.
func updateNotification(productName: String, productID: UUID, expirationDate: Date, numOfDays: Int32) {
    // Remove logic
    removeNotification(productID: productID)
    
    // Add notification
    addNotification(productName: productName, productID: productID, expirationDate: expirationDate, numOfDays: numOfDays)
}

/// Updates notifications for a category of products.
/// - Parameters:
///   - products: The array of `Product` objects that need their notifications updated.
///   - numOfDays: The number of days before the expiration date the user should be notified for each product.
func updateNotificationCategory(products: [Product], numOfDays: Int32) {
    // Update each notification
    for product in products {
        updateNotification(productName: product.name!, productID: product.id!, expirationDate: product.expirationDate!, numOfDays: numOfDays)
    }
}
