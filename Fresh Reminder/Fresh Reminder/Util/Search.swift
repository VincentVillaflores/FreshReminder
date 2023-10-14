//
//  Search.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 21/9/2023.
//

import Foundation

// Case insensitive search function
/// Determines if a given string contains a specified search string.
///
/// This function checks if the `string` parameter contains the `searchString` parameter. If the `searchString` is empty, the function returns `true`. The comparison is case-insensitive.
///
/// - Parameters:
///   - string: The string to be searched within.
///   - searchString: The substring to search for.
/// - Returns: A Boolean value indicating whether the `string` contains the `searchString`. If `searchString` is empty, the function returns `true`.
func isSearchItem(string: String, searchString: String) -> Bool {
    if searchString.isEmpty {
        return true
    }
    
    return string.lowercased().contains(searchString.lowercased())
}
