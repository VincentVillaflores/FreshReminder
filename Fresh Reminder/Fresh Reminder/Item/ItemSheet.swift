//
//  ItemSheet.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 27/8/2023.
//

import SwiftUI

struct ItemSheet: View {
    @Binding
    var item: FridgeItem
    
    @Binding
    var sectionList: [FridgeSection]
    
    var displayDate = true
    
    @State
    var isPresented = false
    
    var body: some View {
        Button {
            isPresented = !isPresented
        } label: {
            HStack{
                VStack(alignment: .leading) {
                    Text(item.itemName)
                    if (displayDate) {
                        Text("Expiry: \(formatDate(date: item.expirationDate))")
                    }
                    
                }.foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }.sheet(isPresented: $isPresented) {
            VStack {
                HStack{
                    Spacer()
                    Button{
                        isPresented = false
                    } label: {
                        Text("Close")
                    }
                }
                Spacer()
                
                Text(item.itemName)
                    .font(.largeTitle)
                    .padding()
                
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    Text("Expiration Date")
                        .padding(.vertical)
                    Text(formatDate(date: item.expirationDate))
                        .padding(.vertical)
                    
                    // Functions to adjust expiry of item
                    Button {
                        item.timeTillExpiration = max(item.timeTillExpiration + daysToSeconds(days: -1), 0)
                    } label: {Text("-1 Day")}
                        .padding(.bottom)
                    Button {
                        item.timeTillExpiration = max(item.timeTillExpiration + daysToSeconds(days: 1), 0)
                    } label: {Text("+1 Day")}
                        .padding(.bottom)
                    Button {
                        item.timeTillExpiration = max(item.timeTillExpiration + daysToSeconds(days: -7), 0)
                    } label: {Text("-1 Week")}
                        .padding(.bottom)
                    Button {
                        item.timeTillExpiration = max(item.timeTillExpiration + daysToSeconds(days: 7), 0)
                    } label: {Text("+1 Week")}
                        .padding(.bottom)
                }.padding().background(.regularMaterial).cornerRadius(10)
                
                // Eat (remove item) button
                Button {
                    // Remove occurrence of item with same UUID in any item category list through filtering
                    for (index, section) in sectionList.enumerated() {
                        sectionList[index].itemList = section.itemList.filter(){$0.id != item.id}
                    }
                    
                    // Close modal view
                    isPresented = false
                } label: {Text("Eat")
                        .foregroundColor(.white)
                        .frame(width: 106, height: 34)
                        .background(Color.accentColor)
                        .cornerRadius(53)
                }.padding()
                
                Spacer()
            }.padding()
        }
    }
}

#if DEBUG
struct ItemSheet_Previews: PreviewProvider {
    static var previews: some View {
        MockItemSheet()
    }
}

struct MockItemSheet: View {
    @State
    var item = FridgeItem(itemName: "Steak", itemCategory: .Meat, dateBought: Date.now, timeTillExpiration: daysToSeconds(days: 4))
    
    @State
    var sectionList = loadFridgeItems()
    
    var body: some View {
        ItemSheet(item: $item, sectionList: $sectionList)
    }
}
#endif
