//
//  NewItemView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 27/8/2023.
//

import SwiftUI

struct NewItemView: View {
    @Environment(\.dismiss)
    private var dismiss
    
    // Expiry can be between 1 day and 4 years
    let expiryRange = 1...1461
    
    let dateBought = Date.now
    
    @State
    var itemName = ""
    
    @State
    var itemCategory: ItemCategory = .Misc
    
    @State
    var expiryDays = 1
    
    @Binding
    var sectionList: [FridgeSection]
    
    var body: some View {
        Form {
            Section{} header: {
                Text(verbatim: "New Item")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }.textCase(nil)
            
            Section(header: Text("Item Information")) {
                TextField("Name", text: $itemName)
                
                Picker("Category", selection: $itemCategory) {
                    Text("Misc").tag(ItemCategory.Misc)
                    Text("Fruit and Vegetables").tag(ItemCategory.FruitVeg)
                    Text("Meat").tag(ItemCategory.Meat)
                    Text("Seafood").tag(ItemCategory.Seafood)
                    Text("Dairy").tag(ItemCategory.Dairy)
                    Text("Grain").tag(ItemCategory.Grain)
                    Text("Mixed").tag(ItemCategory.Mixed)
                }
            }
            
            Section(header: Text("Item Expiry")) {
                Stepper("Expires in \(expiryDays) day" + (expiryDays == 1 ? "" : "s"), value: $expiryDays, in: expiryRange)
            }
            
            HStack {
                Spacer()
                
                Button {
                    // Create category if doesn't exist
                    if !sectionList.contains(where: {$0.itemCategory == itemCategory}) {
                        sectionList.append(FridgeSection(itemCategory: itemCategory, itemList: []))
                    }
                    
                    // Add item to existing category
                    for (index, section) in sectionList.enumerated() {
                        if (section.itemCategory == itemCategory) {
                            sectionList[index].itemList.append(FridgeItem(itemName: itemName, itemCategory: itemCategory, dateBought: dateBought, timeTillExpiration: daysToSeconds(days: expiryDays)))
                        }
                    }
                    
                    // Remove this view from the navigation stack
                    dismiss()
                } label: {
                    Text("Submit")
                }
                
                Spacer()
            }
        }
    }
}

#if DEBUG
struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        MockNewItemView()
    }
}

struct MockNewItemView: View {
    @State
    var sectionList = loadFridgeItems()
    
    var body: some View {
        NewItemView(sectionList: $sectionList)
    }
}
#endif
