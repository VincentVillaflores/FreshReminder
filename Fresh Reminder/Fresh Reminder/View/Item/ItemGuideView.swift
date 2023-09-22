//
//  ItemGuideView.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 21/9/2023.
//

import SwiftUI

struct ItemGuideView: View {
    @ObservedObject
    var viewModel = FoodieViewModel()
    
    @State
    var showTips = false
    
    @State
    var selectedMethod: FoodieMethod? = nil
    
    let guideID: Int32
    
    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                ProgressView().onAppear {viewModel.fetchGuide(guideID: guideID)}
            case .loading:
                ProgressView()
            case .failed(let error):
                Text("\(error.localizedDescription)")
            case .loadedSearch(_):
                EmptyView()
            case .loadedGuide(let foodGuide):
                Form {
                    Section(header: Text("Item")) {
                        Text("\(foodGuide.name)")
                    }
                    
                    Section(header: Text("Storage Location")) {
                        Picker("Method", selection: $selectedMethod) {
                            ForEach(foodGuide.methods, id: \.hashValue) { method in
                                Text(method.location.rawValue).tag(FoodieMethod?.some(method))
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Text( selectedMethod != nil
                              ? "Lasts: \(selectedMethod!.expiration)"
                              : "Please select a storage location"
                        )
                    }
                    Section(header: Text("Storage Tips")) {
                        DisclosureGroup(isExpanded: $showTips) {
                            ForEach(foodGuide.tips, id: \.self.hashValue) { tip in
                                Text(tip)
                            }
                            
                        } label: {
                            Text(showTips ? "Hide": "Show")
                        }
                    }
                }
                .navigationTitle("Add Item")
            }
        }
    }
}

struct ItemGuideView_Previews: PreviewProvider {
    static var previews: some View {
        ItemGuideView(guideID: 16458)
    }
}
