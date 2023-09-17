//
//  FoodieAPIModel.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 17/9/2023.
//

import Foundation
import Combine

enum FoodLocation: String, Codable, CustomStringConvertible {
    case Pantry, Refrigerator, Freezer
    
    var description : String {
        switch self {
        case .Pantry: return "Pantry"
        case .Refrigerator: return "Refrigerator"
        case .Freezer: return "Freezer"
        }
    }
}

struct FoodieSearch: Decodable {
    var id: Int32
    var name: String
    var url: String
}

struct FoodieMethod: Decodable {
    var location: FoodLocation
    var expiration: String
    var expirationTime: Int32
}

struct FoodieGuide: Decodable {
    var name: String
    var methods: [FoodieMethod]
    var tips: [String]
}

// The ObservableObject is a protocol provided by SwiftUI's Combine framework
class FoodieViewModel: ObservableObject {
    private let baseURL = "https://shelf-life.onrender.com"
    
    // this property is published and watched by the content view
    // when data is changed here it will automatically be updated in the view.
    // this property is updated from an asynchronous method running on a background thread.
    @Published
    var searchResults: [FoodieSearch] = []
    
    @Published
    var foodGuide: FoodieGuide? = nil
    
    // represents the subscription to a service
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSearchResults(foodQuery: String) {
        let url = URL(string: "\(baseURL)/search?q=\(foodQuery)")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [FoodieSearch].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Data fetching error: \(error)")
                }
            }, receiveValue: { data in
                self.searchResults = data
            })
            .store(in: &cancellables)
    }
    
    func fetchGuide(guideID: Int32) {
        let url = URL(string: "\(baseURL)/guides/\(guideID)")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FoodieGuide.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Data fetching error: \(error)")
                }
            }, receiveValue: { data in
                self.foodGuide = data
            })
            .store(in: &cancellables)
    }
}
