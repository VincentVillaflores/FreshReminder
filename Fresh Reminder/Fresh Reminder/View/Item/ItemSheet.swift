//
//  ItemSheet.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 27/8/2023.
//

import SwiftUI

struct ItemSheet: View {
    @EnvironmentObject var cdvm: CoreDataViewModel
    
    @Binding
    var item: Product
    
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
                    Text(item.name!)
                    if (displayDate) {
                        Text("Expiry: \(formatDate(date: item.expirationDate!))")
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
                
                Text(item.name!)
                    .font(.largeTitle)
                    .padding()
                
                LazyVGrid(columns: [GridItem(), GridItem()]) {
                    Text("Expiration Date")
                        .padding(.vertical)
                    Text(formatDate(date: item.expirationDate!))
                        .padding(.vertical)
                    
                    // Functions to adjust expiry of item
                    Button {
                        cdvm.addDaysToExpirationDate(days: -1, product: item)
                    } label: {Text("-1 Day")}
                        .padding(.bottom)
                    Button {
                        cdvm.addDaysToExpirationDate(days: 1, product: item)
                    } label: {Text("+1 Day")}
                        .padding(.bottom)
                    Button {
                        cdvm.addDaysToExpirationDate(days: -7, product: item)
                    } label: {Text("-1 Week")}
                        .padding(.bottom)
                    Button {
                        cdvm.addDaysToExpirationDate(days: 7, product: item)
                    } label: {Text("+1 Week")}
                        .padding(.bottom)
                }.padding().background(.regularMaterial).cornerRadius(10)
                
                // Eat (remove item) button
                Button {
                    // Close modal view
                    isPresented = false
                    
                    cdvm.deleteProduct(item)
                    
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
    var item = Product()
    
    @State
    var sectionList = loadFridgeItems()
    
    var body: some View {
        ItemSheet(item: $item, sectionList: $sectionList)
    }
}
#endif
