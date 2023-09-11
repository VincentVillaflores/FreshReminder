//
//  Persistence.swift
//  Fresh Reminder
//
//  Created by Vincent Villaflores on 12/9/2023.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    //to add test data for preview
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

