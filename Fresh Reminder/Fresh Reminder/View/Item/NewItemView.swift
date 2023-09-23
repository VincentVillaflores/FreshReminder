//
//  NewItemView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 27/8/2023.
//

import SwiftUI

struct NewItemView: View {
    @EnvironmentObject var cdvm: CoreDataViewModel
    
    @State
    var itemName = ""
        
    var body: some View {
        Form {
            Section(header: Text("Item Name")) {
                TextField("Name", text: $itemName)
            }
            NavigationLink("Search", value: itemName)
                .disabled(itemName.count < 3)
        }.navigationTitle("Search Item")
    }
}

#if DEBUG
struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        MockNewItemView()
    }
}

struct MockNewItemView: View {
    let persistenceController = PersistenceController.shared
    @StateObject private var cdvm: CoreDataViewModel
    init(){
        let context = persistenceController.container.viewContext
        _cdvm = StateObject(wrappedValue: CoreDataViewModel(context: context))
        cdvm.setUp()
    }
    
    var body: some View {
        NavigationStack {
            NewItemView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cdvm)
        }
    }
}
#endif
