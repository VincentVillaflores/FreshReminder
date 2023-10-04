//
//  CoreDataViewModel.swift
//  Fresh Reminder
//
//  Created by Vincent Villaflores on 13/9/2023.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject{
    private var context: NSManagedObjectContext
    @Published var globalUser: User?
    @Published var products: [Product] = []
    @Published var fruitsVegReminder: Int32? {
        didSet{
            updatePreference(\.fruitVegPreference, with: fruitsVegReminder ?? 1)
        }
    }
    @Published var meatReminder: Int32? {
        didSet{
            updatePreference(\.meatPreference, with: meatReminder ?? 1)
        }
    }
    @Published var seafoodReminder: Int32? {
        didSet{
            updatePreference(\.seafoodPreference, with: seafoodReminder ?? 1)
        }
    }
    @Published var dairyReminder: Int32? {
        didSet{
            updatePreference(\.dairyPreference, with: dairyReminder ?? 1)
        }
    }
    @Published var grainReminder: Int32? {
        didSet{
            updatePreference(\.grainPreference, with: grainReminder ?? 1)
        }
    }
    @Published var mixedReminder: Int32? {
        didSet{
            updatePreference(\.mixedPreference, with: mixedReminder ?? 1)
        }
    }
    @Published var miscReminder: Int32? {
        didSet{
            updatePreference(\.miscPreference, with: miscReminder ?? 1)
        }
    }
    
    /// Saves any changes to the reminder variables to core data.
    ///
    /// Used by fruitsVegReminder, meatReminder, seafoodReminder, dairyReminder, grainReminder, mixedReminder, miscReminder when values change in the Settings view.
    ///
    /// - Parameters:
    ///   - keyPath: The key path in `NotificationPreferences` where the update will take place. For example, \.meatPreference to update the meat reminder setting.
    ///   - value: The new value to set at the given `keyPath`. This is number of days before the expiration date when the user will be notified.
    func updatePreference(_ keyPath: ReferenceWritableKeyPath<NotificationPreferences, Int32>, with value: Int32) {
        guard let user = getUser() else {
            print("User is not initialized")
            return
        }
        user.notification?[keyPath: keyPath] = value
        saveContext()
    }
    
    /// Refreshes the `products` array with the latest data from Core Data.
    ///
    /// This function is useful when the underlying data may have changed and the UI needs to reflect these changes.
    ///
    func refreshProducts() {
        self.products = getAllProducts()
    }
    
    /// Saves the current context to Core Data.
    ///
    /// This function commits any changes to the managed object context to the persistent store.
    /// Upon successful save, it also refreshes the `products` array to reflect these changes.
    ///
    /// - Throws: An error if the save operation fails, printing a description of the error to the console.
    func saveContext(){
        do {
            try context.save()
            refreshProducts()
        } catch {
            print("Failed to save to core data: \(error)")
            print(error.localizedDescription)
        }
    }
    
    /// Initializes a new instance of `CoreDataViewModel`.
    /// 
    /// - Parameter context: The managed object context associated with the Core Data stack. This context is used for data manipulation and saving operations.
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    /// Fetches and returns the currently logged-in `User` object.
    ///
    /// This function first checks if `globalUser` is already set. If so, it returns that user.
    /// Otherwise, it fetches the first user found in the Core Data store. There should only be one user in Core Date store.
    ///
    /// - Returns: The currently logged-in `User` object if available; otherwise, returns `nil` if no user is found or an error occurs during fetch.
    func getUser() -> User?{
        if let user = globalUser {
            return user
        }
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
    
    /// Sets up the initial state for the view model, including populating reminder preferences and refreshing products.
    ///
    /// This function checks if a `User` object is already fetched in `globalUser`.
    /// If `globalUser` is nil, it initializes a new `User` object and sets default reminder preferences.
    /// Otherwise, it updates reminder preferences from the existing `User` object.
    ///
    /// After ensuring that the `User` object exists, it refreshes the list of products.
    ///
    func setUp(){
        refreshProducts()
        if getUser() == nil{
            let newUser = User(context: context)
            globalUser = newUser
            let notification = NotificationPreferences(context: context)
            notification.dairyPreference = 3
            self.dairyReminder = 3
            notification.fruitVegPreference = 3
            self.fruitsVegReminder = 3
            notification.grainPreference = 3
            self.grainReminder = 3
            notification.meatPreference = 3
            self.meatReminder = 3
            notification.miscPreference = 3
            self.miscReminder = 3
            notification.mixedPreference = 3
            self.mixedReminder = 3
            notification.seafoodPreference = 3
            self.seafoodReminder = 3
            newUser.notification = notification
            saveContext()
        }
        else {
            self.globalUser = self.getUser()
            self.dairyReminder = self.globalUser!.notification!.dairyPreference
            self.fruitsVegReminder = self.globalUser!.notification!.fruitVegPreference
            self.grainReminder = self.globalUser!.notification!.grainPreference
            self.meatReminder = self.globalUser!.notification!.meatPreference
            self.miscReminder = self.globalUser!.notification!.miscPreference
            self.mixedReminder = self.globalUser!.notification!.mixedPreference
            self.seafoodReminder = self.globalUser!.notification!.miscPreference
        }
    }
    
    /// Fetches all Product entities from Core Data and returns them sorted by their names in descending order.
    ///
    /// This function attempts to perform a fetch request on the Core Data store to retrieve all `Product` entities.
    /// If the fetch request is successful, the function returns the list of `Product` objects sorted by their names in descending order.
    /// In case of an error during the fetch request, an empty array is returned and the error message is printed to the console.
    ///
    /// - Returns: An array of `Product` entities sorted by their names in descending order, or an empty array in case of failure.
    func getAllProducts() -> [Product]{
        let products: NSFetchRequest<Product> = Product.fetchRequest()
        products.sortDescriptors = [NSSortDescriptor(keyPath: \Product.name, ascending: false)]
        
        do {
            let productsList = try context.fetch(products)
            return productsList
        } catch {
            print("Failed to fetch products: \(error)")
            return []
        }
    }
    
    /// Fetches unique product categories from Core Data and returns them sorted alphabetically.
    ///
    /// This function first fetches all `Product` entities from Core Data via the `getAllProducts()` function.
    /// It then filters out unique category names using a `Set`.
    /// Finally, it returns the unique categories sorted in alphabetical order.
    ///
    /// - Returns: An array of unique `String` values representing the product categories, sorted alphabetically.
    func uniqueCategories() -> [String] {
        var uniqueCategories: Set<String> {
            Set(getAllProducts().compactMap { $0.category })
        }
        return uniqueCategories.sorted()
    }
    
    /// Fetches unique expiration dates from the products array.
    ///
    /// This function iterates through the `products` array, collecting unique expiration dates
    /// into a `Set` of `Date` objects.
    ///
    /// - Returns: A `Set` containing unique `Date` objects representing the expiration dates of the products.
    func uniqueDates() -> Set<Date>{
        var uniqueDateSet: Set<Date> = []
        for product in products {
            uniqueDateSet.insert(product.expirationDate!)
        }
        
        return uniqueDateSet
    }
    
    /// Retrieves products belonging to a specific category.
    ///
    /// This function fetches all products and filters them based on the provided category.
    /// The filtered products are then sorted alphabetically by their name.
    ///
    /// - Parameter category: The category of products to retrieve.
    /// - Returns: An array of `Product` objects belonging to the specified category, sorted by name.
    func getProductsIn(category: String) -> [Product]{
        let categoryItems = getAllProducts().filter { $0.category == category }
        return categoryItems.sorted { $0.name! < $1.name! }
    }
    
    /// Retrieves products that are expiring on a specific date.
    ///
    /// This function filters the existing list of products to find those that have
    /// an expiration date matching the date parameter provided. It formats both the input date
    /// and each product's expiration date to ensure a precise match.
    ///
    /// - Parameter date: The date to check for product expiration.
    /// - Returns: An array of `Product` objects that expire on the specified date.
    func getProductsExpiringOn(date: Date) -> [Product]{
        let expirationDate = formatDate(date: date)
        var expiringProducts: [Product] = []
        
        for product in products {
            let productDate = formatDate(date: product.expirationDate!)
            if (expirationDate == productDate){
                expiringProducts.append(product)
            }
        }
        
        return expiringProducts
    }
    
    /// Adds a new product to the list with detailed information.
    ///
    /// This function creates a new Product object in the Core Data context with the given properties.
    /// It also sets an expiration date for the product by adding the `expiryDays` to the `dateBought`.
    /// The function then saves this new product to Core Data by calling `saveContext()`.
    ///
    /// - Parameters:
    ///   - name: The name of the product.
    ///   - category: The category to which the product belongs.
    ///   - dateBought: The date on which the product was bought.
    ///   - expiryDays: The number of days until the product expires.
    ///   - location: The storage location of the product.
    func addProduct(name: String, category: String, dateBought: Date, expiryDays: Int, location: String) {
        let newItem = Product(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.category = category
        newItem.dateBought = dateBought
        let expiryDate = Calendar.current.date(byAdding: .day, value: expiryDays, to: dateBought)
        newItem.expirationDate = expiryDate
        newItem.user = globalUser
        newItem.location = location
        
        saveContext()
    }
    
    /// Adds a new product with detailed information to Core Data.
    ///
    /// This function creates a new Product object with specified attributes and stores it in Core Data.
    /// It calculates the expiration date by adding the specified number of seconds (`expirySeconds`) to the `dateBought`.
    /// After setting all the attributes, the function saves the object into Core Data by calling `saveContext()`.
    ///
    /// - Parameters:
    ///   - name: The name of the product.
    ///   - category: The category to which the product belongs.
    ///   - dateBought: The date the product was purchased.
    ///   - expirySeconds: The number of seconds until the product expires.
    ///   - location: The location where the product is stored.
    func addProduct(name: String, category: String, dateBought: Date, expirySeconds: Int32, location: String) {
        let newItem = Product(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.category = category
        newItem.dateBought = dateBought
        let expiryDate = Calendar.current.date(byAdding: .second, value: Int(expirySeconds), to: dateBought)
        newItem.expirationDate = expiryDate
        newItem.user = globalUser
        newItem.location = location
        
        saveContext()
    }
    
    /// Deletes a specified product from Core Data.
    ///
    /// This function removes the given `Product` object (`productToDelete`) from Core Data.
    /// After deleting the object, it calls `saveContext()` to persist the changes.
    ///
    /// - Parameter productToDelete: The `Product` object to be deleted from Core Data.
    func deleteProduct(_ productToDelete: Product) {
        context.delete(productToDelete)
        
        saveContext()
    }
    
    /// Adds a specified number of days to a product's expiration date.
    ///
    /// This function extends the expiration date of a given `Product` object (`product`) by a certain
    /// number of days (`days`). It then calls `saveContext()` to persist the changes to Core Data.
    ///
    /// - Parameters:
    ///   - days: The number of days to add to the expiration date.
    ///   - product: The `Product` object whose expiration date is to be extended.
    func addDaysToExpirationDate(days: Double, product: Product) {
        let secondsInADay = 86400
        product.expirationDate?.addTimeInterval(Double(secondsInADay) * days)
        
        saveContext()
    }
    
}
