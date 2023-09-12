//
//  FridgeView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

struct FridgeView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \Product.name, ascending: false) ])
    var productsList: FetchedResults<Product>
    
    var uniqueCategories: Set<String> {
        Set(productsList.compactMap { $0.category })
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
                            let categoryItems = productsList.filter { $0.category == category }
                            
                            // Define the items that belong to this category
                            Section(header: Text(category)){
                                ForEach(categoryItems, id: \.name) { item in
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
        for index in offsets{
            let product = productsList[index]
            context.delete(product)
        }
        
        do {
            try context.save()
        } catch {
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
        FridgeView(sectionList: $sectionList)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
