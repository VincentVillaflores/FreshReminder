//
//  FridgeView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

struct FridgeView: View {
    @EnvironmentObject var cdvm: CoreDataViewModel
    
    var productsList: [Product] {
        return cdvm.products
    }
    
    var uniqueCategories: [String] {
        return cdvm.uniqueCategories()
    }
    
    @State
    var searchString = ""
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(Array(uniqueCategories), id: \.self) { category in
                    var categoryItems: [Product] {
                        return cdvm.getProductsIn(category: category)
                    }
                    
                    // Define the items that belong to this category
                    Section(header: Text(category)){
                        ForEach(categoryItems) { item in
                            ItemSheet(item: Binding.constant(item))
                        }
                        .onDelete(perform: { indexSet in
                            for index in indexSet {
                                cdvm.deleteProduct(categoryItems[index])
                            }
                        })
                    }
                }
            }
            .toolbar {
                MenuButton()
            }
            .navigationTitle("Fresh Reminder")
            .searchable(text: $searchString)
        }
    }
}

#if DEBUG
struct FridgeView_Previews: PreviewProvider {
    static var previews: some View {
        MockFridgeView()
    }
}

struct MockFridgeView: View {
    let persistenceController = PersistenceController.shared
    @StateObject private var cdvm: CoreDataViewModel
    init(){
        let context = persistenceController.container.viewContext
        _cdvm = StateObject(wrappedValue: CoreDataViewModel(context: context))
        cdvm.setUp()
    }
    
    var body: some View {
        FridgeView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(cdvm)
    }
}
#endif
