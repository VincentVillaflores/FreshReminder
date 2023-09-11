//
//  FridgeItem.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 13/8/2023.
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

// List of item categories (used to separate item list into categories)
// Will be replaced when moving to Swift Data models
struct FridgeSection: Identifiable {
    var id = UUID()
    var itemCategory: ItemCategory
    var itemList: [FridgeItem]
}

struct FridgeItem: Identifiable {
    var id = UUID()
    var itemName: String
    var itemCategory: ItemCategory
    var dateBought: Date
    var timeTillExpiration: TimeInterval
    
    var expirationDate: Date {
        let interval = DateInterval(start: dateBought, duration: timeTillExpiration)
        return interval.end
    }
}

func loadFridgeItems() -> [FridgeSection] {
    // TODO: Replace with proper loading logic for assignment 2
    return generateExampleList()
}

// Debug function to generate static list of fridge items
func generateExampleList() -> [FridgeSection] {
    
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    let exampleSectionList: [FridgeSection] = [
        FridgeSection(itemCategory: .FruitVeg, itemList: [
            FridgeItem(itemName: "Apple", itemCategory: .FruitVeg, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 3)),
            FridgeItem(itemName: "Banana", itemCategory: .FruitVeg, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 4)),
            FridgeItem(itemName: "Lettuce", itemCategory: .FruitVeg, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 4)),
            FridgeItem(itemName: "Eggplant", itemCategory: .FruitVeg, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 3))
        ]),
        FridgeSection(itemCategory: .Meat, itemList: [
            FridgeItem(itemName: "Steak", itemCategory: .Meat, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 7))
        ]),
        FridgeSection(itemCategory: .Seafood, itemList: [
            FridgeItem(itemName: "Prawns", itemCategory: .Seafood, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 2))
        ]),
        FridgeSection(itemCategory: .Misc, itemList: [
            FridgeItem(itemName: "Chips", itemCategory: .Misc, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 365))
        ]),
        FridgeSection(itemCategory: .Grain, itemList: [
            FridgeItem(itemName: "Rice", itemCategory: .Grain, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 365)),
            FridgeItem(itemName: "Bread", itemCategory: .Grain, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 5))
        ]),
        FridgeSection(itemCategory: .Mixed, itemList: [
            FridgeItem(itemName: "Pizza", itemCategory: .Mixed, dateBought: dateFormatter.date(from: "13/08/2023")!, timeTillExpiration: daysToSeconds(days: 1))
        ])
    ]
    
    return exampleSectionList
}
