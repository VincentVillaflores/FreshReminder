//
//  ItemGuideView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 21/9/2023.
//

import SwiftUI

struct ItemGuideView: View {
    @EnvironmentObject
    var cdvm: CoreDataViewModel
    
    @ObservedObject
    var viewModel = FoodieViewModel()
    
    let guideID: Int32
    
    @Binding
    var path: NavigationPath
    
    @State
    var showTips = false
    
    @State
    var itemCategory: ItemCategory? = nil
    
    @State
    var selectedMethod: FoodieMethod? = nil
    
    let calendar = Calendar.current
    
    var currDate: Date { getStartOfDay(date: Date.now, calendar: calendar) }
    
    var body: some View {
        
            switch viewModel.state {
            case .idle:
                ProgressView().onAppear {viewModel.fetchGuide(guideID: guideID)}
            case .loading:
                ProgressView()
            case .failed(let error):
                VStack {
                    Text("\(error.localizedDescription)")
                    Text("Please try again later.")
                }
            case .loadedSearch(_):
                EmptyView()
            case .loadedGuide(let foodGuide):
                Form {
                    Section(header: Text("Item")) {
                        Text(foodGuide.name)
                    }
                    
                    Section(header: Text("Item Category")) {
                        Picker("Category", selection: $itemCategory) {
                            Text("Please select").tag(ItemCategory?.none)
                            Text("Fruit and Vegetable").tag(ItemCategory?.some(.FruitVeg))
                            Text("Meat").tag(ItemCategory?.some(.Meat))
                            Text("Seafood").tag(ItemCategory?.some(.Seafood))
                            Text("Dairy").tag(ItemCategory?.some(.Dairy))
                            Text("Grain").tag(ItemCategory?.some(.Grain))
                            Text("Mixed").tag(ItemCategory?.some(.Mixed))
                            Text("Other").tag(ItemCategory?.some(.Misc))
                        }
                    }
                    
                    Section(header: Text("Storage Location")) {
                        Picker("Method", selection: $selectedMethod) {
                            ForEach(foodGuide.methods, id: \.hashValue) { method in
                                Text(method.location.rawValue).tag(FoodieMethod?.some(method))
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Text( selectedMethod != nil
                              ? "Lasts: \(selectedMethod!.expiration)"
                              : "Please select a storage location"
                        ).bold(selectedMethod == nil)
                    }
                    
                    Section(header: Text("Storage Tips")) {
                        DisclosureGroup(isExpanded: $showTips) {
                            ForEach(foodGuide.tips, id: \.self.hashValue) { tip in
                                Text(tip)
                            }
                            
                        } label: {
                            Text(showTips ? "Hide": "Show")
                        }
                    }
                }
                .toolbar {
                    Button("Submit") {
                        let expiryTime = (selectedMethod!.expirationTime != -1) ? selectedMethod!.expirationTime : Int32.max
                        
                        cdvm.addProduct(
                            name: foodGuide.name,
                            category: itemCategory!.description,
                            dateBought: currDate,
                            expirySeconds: expiryTime,
                            location: selectedMethod!.location.rawValue
                        )
                        
                        path = NavigationPath()
                    }.disabled(
                        selectedMethod == nil || itemCategory == nil
                    )
                }
                .navigationTitle("Add Item")
            }
        
    }
}

#if DEBUG
struct ItemGuideView_Previews: PreviewProvider {
    static var previews: some View {
        MockItemGuideView()
    }
}

struct MockItemGuideView: View {
    let persistenceController = PersistenceController.shared
    @StateObject private var cdvm: CoreDataViewModel
    init(){
        let context = persistenceController.container.viewContext
        _cdvm = StateObject(wrappedValue: CoreDataViewModel(context: context))
        cdvm.setUp()
    }
    
    @State
    var path = NavigationPath()
    
    var body: some View {
        NavigationStack {
            ItemGuideView(guideID: 16448, path: $path)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cdvm)
        }
    }
}
#endif
