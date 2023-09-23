//
//  ItemSearchView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 17/9/2023.
//

import SwiftUI

struct ItemSearchView: View {
    @ObservedObject
    var viewModel = FoodieViewModel()
    
    let itemSearch: String
    
    var body: some View {
            switch viewModel.state {
            case .idle:
                ProgressView().onAppear {viewModel.fetchSearchResults(foodQuery: itemSearch)}
            case .loading:
                ProgressView()
            case .failed(let error):
                VStack {
                    Text("\(error.localizedDescription)")
                    Text("Please try again later.")
                }
                
            case .loadedGuide(_):
                EmptyView()
                
            case .loadedSearch(let searchResults):
                List {
                    if !searchResults.isEmpty {
                        ForEach(searchResults, id: \.id) { searchResult in
                            NavigationLink(searchResult.name, value: searchResult.id)
                        }
                    } else {
                        Text("No matching items")
                    }
                }
                .navigationTitle("Matching items")
            }
    }
}

#if DEBUG
struct ItemSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MockItemSearchView()
    }
}

struct MockItemSearchView: View {
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
            ItemSearchView(itemSearch: "Banana")
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(cdvm)
        }
    }
}
#endif
