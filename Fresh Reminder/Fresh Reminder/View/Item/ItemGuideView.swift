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
                Form {
                    Text("")
                }
            case .loadedGuide(let foodGuide):
                Form {
                    Text("\(foodGuide.name)")
                }
            }
        }
    }
}

struct ItemGuideView_Previews: PreviewProvider {
    static var previews: some View {
        ItemGuideView(guideID: 16457)
    }
}
