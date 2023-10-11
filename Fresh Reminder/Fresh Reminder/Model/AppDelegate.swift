//
//  AppDelegate.swift
//  Fresh Reminder
//
//  Created by Vincent Villaflores on 9/10/2023.
//

import UserNotifications
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

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

func removeNotification(productID: UUID) {
    let center = UNUserNotificationCenter.current()
    let notifUUID = productID.uuidString
    
    center.removePendingNotificationRequests(withIdentifiers: [notifUUID])
}

func updateNotification(productName: String, productID: UUID, expirationDate: Date, numOfDays: Int32) {
    // Remove logic
    removeNotification(productID: productID)
    
    // Add notification
    addNotification(productName: productName, productID: productID, expirationDate: expirationDate, numOfDays: numOfDays)
}

func updateNotificationCategory(products: [Product], numOfDays: Int32) {
    // Update each notification
    for product in products {
        updateNotification(productName: product.name!, productID: product.id!, expirationDate: product.expirationDate!, numOfDays: numOfDays)
    }
}
