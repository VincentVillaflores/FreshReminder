//
//  FridgeView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

struct FridgeView: View {
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
                        
                        ForEach($sectionList, id: \.id) { $section in
                            // Item Category
                            Section(section.itemCategory.description) {
                                // Items within selected item category
                                ForEach($section.itemList, id: \.id) { $item in
                                    if isSearchItem(string: item.itemName, searchString: searchString) {
                                        
                                        ItemSheet(item: $item, sectionList: $sectionList)
                                    }
                                }.onDelete { (indexSet) in
                                    section.itemList.remove(atOffsets: indexSet)
                                }
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
    }
}
#endif
