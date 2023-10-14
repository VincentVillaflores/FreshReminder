//
//  FridgeView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

/// The main view responsible for displaying the contents of the fridge, grouped by category.
struct FridgeView: View {
    @EnvironmentObject var cdvm: CoreDataViewModel

    /// List of all products in the fridge.
    var productsList: [Product] {
        return cdvm.products
    }

    /// List of unique product categories.
    var uniqueCategories: [String] {
        return cdvm.uniqueCategories()
    }
    
    /// Text input for search functionality.
    @State
    var searchString = ""
    
    /// Navigation path used for the navigation stack.
    @State
    var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(Array(uniqueCategories), id: \.self) { category in
                    var categoryItems: [Product] {
                        return cdvm.getProductsIn(category: category)
                    }
                    
                    // Define the items that belong to this category
                    Section(header: Text(category)){
                        ForEach(categoryItems) { item in
                            if isSearchItem(string: item.name ?? "", searchString: searchString) {
                                ItemSheet(item: Binding.constant(item))
                            }
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
                NavigationLink(value: Destinations.searchItem) {
                    Image(systemName: "plus")
                }
            }
            .navigationDestination(for: Destinations.self) { destination in
                NewItemView()
            }
            .navigationDestination(for: String.self) { textValue in
                ItemSearchView(itemSearch: textValue)
            }
            .navigationDestination(for: Int32.self) { numberValue in
                ItemGuideView(guideID: numberValue, path: $path)
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
