//
//  SearchBar.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 21/8/2023.
//

import SwiftUI

// Case insensitive search function
func isSearchItem(string: String, searchString: String) -> Bool {
    if searchString.isEmpty {
        return true
    }
    
    return string.lowercased().contains(searchString.lowercased())
}

struct SearchBar: View {
    @Binding
    var search: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField(
                "Search",
                text: $search
            )
        }
    }
}
