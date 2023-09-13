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
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getUser() -> User?{
        if let user = globalUser {
                return user
        }
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")

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
            do {
                try context.save()
            } catch {
                print("Error saving: \(error)")
            }
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
    
    func refreshProducts() {
        self.products = getAllProducts()
    }
    
    func addProduct(name: String, category: String, dateBought:Date, expiryDays:Int){
        let newItem = Product(context: context)
        newItem.id = UUID()
        newItem.name = name
        newItem.category = category
        newItem.dateBought = dateBought
        let expiryDate = Calendar.current.date(byAdding: .day, value: expiryDays, to: dateBought)
        newItem.expirationDate = expiryDate
        newItem.user = globalUser
        
        do {
            try context.save()
            refreshProducts()
        } catch {
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteProduct(_ productToDelete: Product) {
        context.delete(productToDelete)
        
        do {
            try context.save()
            refreshProducts()
        } catch {
            print("Failed to delete products: \(error)")
        }
    }
    
}
