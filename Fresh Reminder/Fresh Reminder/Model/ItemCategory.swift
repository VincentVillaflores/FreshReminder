//
//  ItemCategory.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 23/9/2023.
//

import Foundation

// Enum to describe category of item, along with string description of category
/// Represents the various categories an item can belong to.
///
/// This enumeration lists different food categories and provides a
/// human-readable description for each of them. It conforms to the
/// `CustomStringConvertible` protocol to provide a custom string
/// representation for its cases.
///
/// - Cases:
///   - FruitVeg: Represents fruits and vegetables.
///   - Meat: Represents various types of meat.
///   - Seafood: Represents various types of seafood.
///   - Dairy: Represents dairy products.
///   - Grain: Represents grains and grain-based products.
///   - Mixed: Represents products that fall into multiple categories.
///   - Misc: Represents miscellaneous items that don't fit into other categories.
enum ItemCategory: CustomStringConvertible {
    case FruitVeg
    case Meat
    case Seafood
    case Dairy
    case Grain
    case Mixed
    case Misc
    
    var description : String {
        switch self {
        case .FruitVeg: return "Fruit & Vegetables"
        case .Meat: return "Meat"
        case .Seafood: return "Seafood"
        case .Dairy: return "Dairy"
        case .Grain: return "Grain"
        case .Mixed: return "Mixed"
        case .Misc: return "Miscellaneous"
        }
    }
}
