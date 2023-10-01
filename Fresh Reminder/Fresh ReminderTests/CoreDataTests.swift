//
//  CoreDataTests.swift
//  Fresh ReminderTests
//
//  Created by Vincent Villaflores on 1/10/2023.
//

import XCTest
import CoreData
@testable import Fresh_Reminder

class CoreDataViewModelTests: XCTestCase {
    var coreDataViewModel: CoreDataViewModel!
    var mockContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        // Initialize an in-memory managed object context
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "Model")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        mockContext = container.viewContext
        
        // Initialize your view model with the mock context
        coreDataViewModel = CoreDataViewModel(context: mockContext)
        coreDataViewModel.setUp()
        let dateBought = Date()
        coreDataViewModel.addProduct(name: "Mango", category: "Fruit & Vegetables", dateBought: dateBought, expiryDays: 10, location: "Refrigerator")
        coreDataViewModel.addProduct(name: "Melon", category: "Fruit & Vegetables", dateBought: dateBought, expiryDays: 10, location: "Refrigerator")
        coreDataViewModel.addProduct(name: "Steak", category: "Meat", dateBought: Date(), expiryDays: 20, location: "Refrigerator")
    }
    
    func testChangeNotificationPreferences(){
        coreDataViewModel.dairyReminder = 6
        coreDataViewModel.fruitsVegReminder = 7
        coreDataViewModel.meatReminder = 8
        coreDataViewModel.seafoodReminder = 9
        coreDataViewModel.grainReminder = 10
        coreDataViewModel.mixedReminder = 11
        coreDataViewModel.miscReminder = 12
        
        let user = coreDataViewModel.getUser()
        let userDairyReminder = user?.notification?.dairyPreference
        let userFruitsVegReminder = user?.notification?.fruitVegPreference
        let userMeatReminder = user?.notification?.meatPreference
        let userSeafoodReminder = user?.notification?.seafoodPreference
        let userGrainReminder = user?.notification?.grainPreference
        let userMixReminder = user?.notification?.mixedPreference
        let userMiscReminder = user?.notification?.miscPreference
        
        XCTAssertEqual(userDairyReminder, 6, "User dairy reminder should be 6")
        XCTAssertEqual(userFruitsVegReminder, 7, "User fruits & veg reminder should be 7")
        XCTAssertEqual(userMeatReminder, 8, "User meat reminder should be 8")
        XCTAssertEqual(userSeafoodReminder, 9, "User seafood reminder should be 9")
        XCTAssertEqual(userGrainReminder, 10, "User grain reminder should be 10")
        XCTAssertEqual(userMixReminder, 11, "User mix reminder should be 11")
        XCTAssertEqual(userMiscReminder, 12, "User misc reminder should be 12")
    }
    
    func testInitialNotificationPreferences(){
        let intialDairyReminder = coreDataViewModel.dairyReminder
        let initialFruitsVegReminder = coreDataViewModel.fruitsVegReminder
        let initialMeatReminder = coreDataViewModel.meatReminder
        let initialSeafoodReminder = coreDataViewModel.seafoodReminder
        let initialGrainReminder = coreDataViewModel.grainReminder
        let intialMixedReminder = coreDataViewModel.mixedReminder
        let initialMiscReminder = coreDataViewModel.miscReminder
        
        XCTAssertEqual(intialDairyReminder, 3, "Dairy reminder should be 3")
        XCTAssertEqual(initialFruitsVegReminder, 3, "Fruits & Veg reminder should be 3")
        XCTAssertEqual(initialMeatReminder, 3, "Meat reminder should be 3")
        XCTAssertEqual(initialSeafoodReminder, 3, "Seafood reminder should be 3")
        XCTAssertEqual(initialGrainReminder, 3, "Grain reminder should be 3")
        XCTAssertEqual(intialMixedReminder, 3, "Mixed reminder should be 3")
        XCTAssertEqual(initialMiscReminder, 3, "Misc reminder should be 3")
    }
    
    func testGetUser(){
        let user = coreDataViewModel.getUser()
        
        XCTAssertNotNil(user, "getUser should return a User object")
    }
    
    func testUniqueCategories(){
        let uniqueCategories = coreDataViewModel.uniqueCategories().count
        
        XCTAssertEqual(uniqueCategories, 2, "Unique categories count should be 2")
    }
    
    func testUniqueDates(){
        let uniqueDatesCount = coreDataViewModel.uniqueDates().count
        
        XCTAssertEqual(uniqueDatesCount, 2, "Unique dates count should be 2")
    }

    func testGetProductsIn(){
        let fruitCount = coreDataViewModel.getProductsIn(category: "Fruit & Vegetables").count
        let meatCount = coreDataViewModel.getProductsIn(category: "Meat").count
        
        XCTAssertEqual(fruitCount, 2, "Fruit & Vegetables count should be 2")
        XCTAssertEqual(meatCount, 1, "Meat count should be 1")
    }
    
    func testGetAllProducts(){
        let afterProductCount = coreDataViewModel.getAllProducts().count
        
        XCTAssertEqual(3, afterProductCount, "Product count should increase by 3")
    }
    
    func testGetProductsExpiringOn(){
        let expiryDate1 = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        let expiryDate2 = Calendar.current.date(byAdding: .day, value: 20, to: Date())
        
        let productCount1 = coreDataViewModel.getProductsExpiringOn(date: expiryDate1!).count
        let productCount2 = coreDataViewModel.getProductsExpiringOn(date: expiryDate2!).count
        
        XCTAssertEqual(productCount1, 2, "Expiring product in 10 days count should be 2")
        XCTAssertEqual(productCount2, 1, "Expiring product in 20 days count should be 1")
    }
    
    func testAddProduct() {
        let initialProductCount = coreDataViewModel.getAllProducts().count
        coreDataViewModel.addProduct(name: "Apple", category: "Fruit & Vegetables", dateBought: Date(), expiryDays: 10, location: "Refrigerator")
        
        let afterProductCount = coreDataViewModel.getAllProducts().count
        
        XCTAssertEqual(afterProductCount, initialProductCount + 1, "Product count should increase by 1")
    }
    
    func testDeleteProduct(){
        let newProduct = Product(context: mockContext)
        newProduct.id = UUID()
        newProduct.name = "Apple"
        newProduct.category = "Fruits & Vegetables"
        newProduct.dateBought = Date()
        let expiryDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        newProduct.expirationDate = expiryDate
        coreDataViewModel.saveContext()
        
        let initialProductCount = coreDataViewModel.getAllProducts().count
        coreDataViewModel.deleteProduct(newProduct)
        
        let afterProductCount = coreDataViewModel.getAllProducts().count
        
        XCTAssertEqual(afterProductCount + 1, initialProductCount, "Product count should decrease by 1")
    }
    
    func testAddDaysToExpirationDate(){
        let newProduct = Product(context: mockContext)
        newProduct.id = UUID()
        newProduct.name = "Apple"
        newProduct.category = "Fruits & Vegetables"
        newProduct.dateBought = Date()
        let expiryDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        newProduct.expirationDate = expiryDate
        coreDataViewModel.saveContext()
        
        let initialExpirationDate = expiryDate
        coreDataViewModel.addDaysToExpirationDate(days: 10, product: newProduct)
        
        let afterExpirationDate = newProduct.expirationDate
        // add 10 days to the inital expiration date
        let testExpirationDate = Calendar.current.date(byAdding: .day, value: 10, to: initialExpirationDate!)
        
        XCTAssertEqual(testExpirationDate, afterExpirationDate, "Expiration date should increase by 10")
    }

    
}
