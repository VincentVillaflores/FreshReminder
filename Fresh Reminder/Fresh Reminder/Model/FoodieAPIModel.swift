//
//  FoodieAPIModel.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 17/9/2023.
//

import Foundation
import Combine

/// Represents the location of food items in storage.
///
/// This enum provides predefined locations where food can be stored in a household, ensuring consistency in data entry and retrieval.
///
/// - Pantry: A location typically reserved for dry and canned foods.
/// - Refrigerator: A cool storage location used for perishable foods.
/// - Freezer: A location designed to store foods at freezing temperatures for long-term preservation.
enum FoodLocation: String, Codable {
    case Pantry
    case Refrigerator
    case Freezer
}

/// Represents a search result for a food item.
///
/// This struct encapsulates the primary attributes of a food item retrieved from a search operation. Each food item has a unique identifier, a name, and a URL associated with it.
///
/// - `id`: The unique identifier for the food item.
/// - `name`: The name or title of the food item.
/// - `url`: The URL where more information about the food item can be accessed.
struct FoodieSearch: Decodable {
    var id: Int32
    var name: String
    var url: String
}

/// Represents the storage method for a food item.
///
/// This struct encapsulates information about how a specific food item should be stored, including its location, expiration date, and expiration time. It also conforms to the `Hashable` protocol, enabling it to be used in data structures like `Set` or as a dictionary key.
///
/// - `location`: The designated location for storing the food item, such as the pantry, refrigerator, or freezer.
/// - `expiration`: A string representation of the expiration date for the food item.
/// - `expirationTime`: The time, in seconds, for the food item to expire from its date of purchase or production.
struct FoodieMethod: Decodable, Hashable {
    var location: FoodLocation
    var expiration: String
    var expirationTime: Int32
    
    /// Incorporates the location's raw value into the given hasher, ensuring unique hash values for different locations.
    ///
    /// This method is used to customize the hashing behavior of the `FoodieMethod` object, specifically leveraging the `location` property's raw value for hash calculations. This ensures that two `FoodieMethod` objects with different `location` values will, in most cases, have different hash values.
    ///
    /// - Parameter hasher: The hasher to use when combining the multiple hash values, guaranteeing the object's uniqueness in collections.
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.rawValue)
    }
    
    /// Determines the equality between two `FoodieMethod` instances based on their `location` property.
    ///
    /// This method checks if two `FoodieMethod` objects have the same `location` values. Objects are considered equal if their `location` properties have the same raw values.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `FoodieMethod` object to compare.
    ///   - rhs: The right-hand side `FoodieMethod` object to compare.
    /// - Returns: A Boolean value indicating whether the two `FoodieMethod` objects have the same `location` values.
    static func == (lhs: FoodieMethod, rhs: FoodieMethod) -> Bool {
        return lhs.location.rawValue == rhs.location.rawValue && lhs.location.rawValue == rhs.location.rawValue
    }
}

/// Represents a comprehensive guide for a specific food item.
///
/// This structure contains information about the proper storage methods,
/// recommended expiration durations, and general tips for a food item.
///
/// - Properties:
///   - name: The name of the food item.
///   - methods: An array of `FoodieMethod` objects that detail various storage methods and expiration times.
///   - tips: An array of strings containing tips related to the food item.
struct FoodieGuide: Decodable {
    var name: String
    var methods: [FoodieMethod]
    var tips: [String]
}


