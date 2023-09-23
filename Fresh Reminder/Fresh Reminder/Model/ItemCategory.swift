//
//  ItemCategory.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 23/9/2023.
//

import Foundation

// Enum to describe category of item, along with string description of category
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
