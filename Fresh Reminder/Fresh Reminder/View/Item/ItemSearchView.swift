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
    
    var body: some View {
        let searchResults = viewModel.searchResults
        
        List {
            Button("Fetch apples") {
                viewModel.fetchSearchResults(foodQuery: "Apple")
            }
            
            if let foodGuide = viewModel.foodGuide {
                Section(header: Text("Name: \(foodGuide.name)")) {
                    ForEach(foodGuide.methods, id: \.location.rawValue) { method in
                        Text("\(method.location.rawValue)")
                        Text("\(method.expiration)")
                        Text("\(method.expirationTime)")
                    }
                }
            } else {
                Text("Guide not available")
            }
            
            if !searchResults.isEmpty {
                ForEach(searchResults, id: \.id) { searchResult in
                    Section(header: Text("Name: \(searchResult.name)")) {
                        Button("Id: \(searchResult.id)") {
                            viewModel.fetchGuide(guideID: searchResult.id)
                        }
                        Text("URL: \(searchResult.url)")
                    }
                }
            } else {
                Text("No matching items")
            }
        }.onAppear {
            viewModel.fetchSearchResults(foodQuery: "BANANAS - RAW")
        }
    }
}

struct ItemSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ItemSearchView()
    }
}
