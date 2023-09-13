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
    
    @Binding
    var sectionList: [FridgeSection]
    
    @State
    var searchString = ""

    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    
                    List {
                        Section{} header: {
                            Text(verbatim: "Fresh Reminder")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        }.textCase(nil)
                        
                        SearchBar(search: $searchString)
                        
                        
                        ForEach(Array(uniqueCategories), id: \.self) { category in
                            var categoryItems: [Product] {
                                return cdvm.getProductsIn(category: category)
                            }
                            
                            // Define the items that belong to this category
                            Section(header: Text(category)){
                                ForEach(categoryItems) { item in
                                    ItemSheet(item: Binding.constant(item), sectionList: $sectionList)
                                }
                                .onDelete(perform: removeItem)
                            }
                        }
                        ListSpacer()
                    }
                }
                
                // Menu button to navigate to manual item input / camera input
                FloatingButton(sectionList: $sectionList)
            }
        }
    }
    
    func removeItem(at offsets:IndexSet){
        var flattenedProducts: [Product] = []
        for category in uniqueCategories {
            flattenedProducts.append(contentsOf: cdvm.getProductsIn(category: category))
        }

        // Loop through offsets and delete corresponding products
        for offset in offsets {
            if offset < flattenedProducts.count {
                let productToDelete = flattenedProducts[offset]
                cdvm.deleteProduct(productToDelete)
            }
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
    @State
    var sectionList = loadFridgeItems()
    
    var body: some View {
        let cdvm = CoreDataViewModel(context: PersistenceController.preview.container.viewContext)
        FridgeView(sectionList: $sectionList)
            .environmentObject(cdvm)
    }
}
#endif
