//
//  Search.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 21/9/2023.
//

import Foundation

// Case insensitive search function
func isSearchItem(string: String, searchString: String) -> Bool {
    if searchString.isEmpty {
        return true
    }
    
    return string.lowercased().contains(searchString.lowercased())
}
