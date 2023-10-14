//
//  FoodieAPIViewModel.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 14/10/2023.
//

import Foundation
import Combine

// The ObservableObject is a protocol provided by SwiftUI's Combine framework
/// ViewModel responsible for fetching and managing food-related data.
///
/// This ViewModel interacts with an external API to fetch search results for food items
/// and detailed guides on various food items. The fetched data is stored in published
/// properties which can be observed by a SwiftUI view for updates.
///
/// - Properties:
///   - state: Represents the current state of a data fetch operation.
///   - searchResults: Contains the list of food items returned from a search query.
///   - foodGuide: Contains detailed information about a specific food item.
class FoodieViewModel: ObservableObject {
    
    /// Represents the possible states during a data fetch operation.
    enum State {
        case idle
        case loading
        case failed(Error)
        case loadedSearch([FoodieSearch])
        case loadedGuide(FoodieGuide)
    }
    
    @Published var state: State = .idle
    private let baseURL = "https://shelf-life.onrender.com"
    
    // this property is published and watched by the content view
    // when data is changed here it will automatically be updated in the view.
    // this property is updated from an asynchronous method running on a background thread.
    @Published var searchResults: [FoodieSearch] = []
    @Published var foodGuide: FoodieGuide? = nil
    
    // represents the subscription to a service
    private var cancellables = Set<AnyCancellable>()
    
    // represents the subscription to a service
    /// Fetches search results for the specified food query.
    ///
    /// - Parameter foodQuery: The food item to search for.
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
                self.state = .loadedSearch(data)
            })
            .store(in: &cancellables)
    }
    
    /// Fetches a detailed guide for the specified food ID.
    ///
    /// - Parameter guideID: The ID of the food item to fetch details for.
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
            })
            .store(in: &cancellables)
    }
}
