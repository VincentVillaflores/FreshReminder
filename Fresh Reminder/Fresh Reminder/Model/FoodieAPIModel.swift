//
//  FoodieAPIModel.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 17/9/2023.
//

import Foundation
import Combine

enum FoodLocation: String, Codable {
    case Pantry
    case Refrigerator
    case Freezer
}

struct FoodieSearch: Decodable {
    var id: Int32
    var name: String
    var url: String
}

struct FoodieMethod: Decodable, Hashable {
    var location: FoodLocation
    var expiration: String
    var expirationTime: Int32
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.rawValue)
    }
    
    static func == (lhs: FoodieMethod, rhs: FoodieMethod) -> Bool {
        return lhs.location.rawValue == rhs.location.rawValue && lhs.location.rawValue == rhs.location.rawValue
    }
}

struct FoodieGuide: Decodable {
    var name: String
    var methods: [FoodieMethod]
    var tips: [String]
}

// The ObservableObject is a protocol provided by SwiftUI's Combine framework
class FoodieViewModel: ObservableObject {
    enum State {
            case idle
            case loading
            case failed(Error)
            case loadedSearch([FoodieSearch])
            case loadedGuide(FoodieGuide)
    }
    
    @Published
    var state: State = .idle
    
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
        state = .loading
        
        let url = URL(string: "\(baseURL)/search?q=\(foodQuery.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [FoodieSearch].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.state = .failed(error)
                }
            }, receiveValue: { data in
                self.searchResults = data
            })
            .store(in: &cancellables)
    }
    
    func fetchGuide(guideID: Int32) {
        state = .loading
        
        let url = URL(string: "\(baseURL)/guides/\(guideID)")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FoodieGuide.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.state = .failed(error)
                }
            }, receiveValue: { data in
                self.state = .loadedGuide(data)
                print("Got \(guideID)")
                print(data.name)
            })
            .store(in: &cancellables)
    }
}
