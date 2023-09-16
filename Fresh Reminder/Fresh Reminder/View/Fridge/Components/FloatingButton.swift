//
//  FloatingButton.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(Color(UIColor.tertiarySystemBackground))
            .foregroundStyle(.green)
            .clipShape(Circle())
            .shadow(radius: 1)
            .offset(x:-20, y:-20)
    }
}

struct FloatingButton: View {
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Menu {
                    NavigationLink {
                        NewItemView()
                    } label: {
                        Text("New Item")
                    }
                    
                    Button {} label: {
                        Text("Take Photo of Item")
                    }
                } label: {
                    Image(systemName: "plus")
                        .padding(20)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .foregroundStyle(.green)
                        .clipShape(Circle())
                        .shadow(radius: 1)
                        .offset(x:-20, y:-20)
                }
            }
        }
    }
}

#if DEBUG
struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        MockFloatingButton()
    }
}

struct MockFloatingButton: View {
    
    var body: some View {
        FloatingButton()
    }
}
#endif
