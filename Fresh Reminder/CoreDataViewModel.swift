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
    
    func updatePreference(_ keyPath: ReferenceWritableKeyPath<NotificationPreferences, Int32>, with value: Int32) {
        guard let user = getUser() else {
            print("User is not initialized")
            return
        }
        user.notification?[keyPath: keyPath] = value
        saveContext()
    }
    
    func refreshProducts() {
        self.products = getAllProducts()
    }
    
    func saveContext(){
        do {
            try context.save()
            refreshProducts()
        } catch {
            print("Failed to delete products: \(error)")
            print(error.localizedDescription)
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
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
    
    func uniqueCategories() -> [String] {
        var uniqueCategories: Set<String> {
            Set(getAllProducts().compactMap { $0.category })
        }
        return uniqueCategories.sorted()
    }
    
    func uniqueDates() -> Set<Date>{
        var uniqueDateSet: Set<Date> = []
        for product in products {
            uniqueDateSet.insert(product.expirationDate!)
        }
        
        return uniqueDateSet
        
    }
    
    func getProductsIn(category: String) -> [Product]{
        let categoryItems = getAllProducts().filter { $0.category == category }
        return categoryItems.sorted { $0.name! < $1.name! }
    }
    
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
    
    func addProduct(name: String, category: String, dateBought:Date, expiryDays:Int, location: String) {
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
    
    func addProduct(name: String, category: String, dateBought:Date, expirySeconds:Int32, location: String) {
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
    
    func deleteProduct(_ productToDelete: Product) {
        context.delete(productToDelete)
        
        saveContext()
    }
    
    func addDaysToExpirationDate(days: Double, product: Product){
        let secondsInADay = 86400
        product.expirationDate?.addTimeInterval(Double(secondsInADay)*days)
        
        saveContext()
    }
    
}
