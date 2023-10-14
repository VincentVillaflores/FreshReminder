//
//  Persistence.swift
//  Fresh Reminder
//
//  Taken from week 7 practical 04/09/2023.
//  Created by Vincent Villaflores on 12/9/2023.
//

import Foundation
import CoreData

/// Manages the Core Data stack for the application.
///
/// This structure provides an interface for managing persistent storage using Core Data. It offers a shared instance for accessing the app's `NSPersistentContainer` and a preview version with sample data for SwiftUI previews or other testing purposes.
///
/// - Properties:
///   - `shared`: A shared instance of `PersistenceController` to be used throughout the app.
///   - `container`: The app's persistent container, managing the life cycle of the Core Data stack.
///
/// - Initialization:
///   - `inMemory`: A Boolean flag indicating whether the controller should use an in-memory store. Useful for testing or preview purposes.
///
/// - Computed Properties:
///   - `preview`: A static instance of `PersistenceController` pre-populated with sample data for SwiftUI previews or other testing scenarios.
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    //to add test data for preview
    /// Provides a sample `PersistenceController` instance populated with test data.
    ///
    /// This instance uses an in-memory data store and is pre-loaded with sample data, making it ideal for SwiftUI previews or unit testing scenarios.
    ///
    /// Sample data includes:
    /// - A user with a sample email and name.
    /// - Four products under the category "Fruits and Vegetables" with different expiration dates.
    ///
    /// - Returns: A fully initialized `PersistenceController` containing the sample data.
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let user1 = User(context: viewContext)
        user1.email = "this@email.com"
        user1.name = "this name"
        
        let stringList = ["Apple", "Banana", "Cherry", "Mango"]
        
        let currentDate = Date()
        let calendar = Calendar.current

        for index in 0..<stringList.count {
            let newItem = Product(context: viewContext)
            newItem.name = stringList[index]
            newItem.category = "Fruits and Vegetables"
            newItem.quantity = 1
            let expirationDate = calendar.date(byAdding: .day, value: index, to: currentDate)
            newItem.expirationDate = expirationDate
            newItem.user = user1
        }
        
        do {
            try viewContext.save()
        } catch {
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()
    
    /// Initializes a new `PersistenceController`.
    ///
    /// Initializes the core data stack and loads persistent stores. Optionally, you can choose to initialize with an in-memory data store which is useful for testing.
    ///
    /// - Parameter inMemory: A flag that determines whether the data should be stored in memory (transient) or persisted on disk. Default is `false` (persisted on disk).
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
