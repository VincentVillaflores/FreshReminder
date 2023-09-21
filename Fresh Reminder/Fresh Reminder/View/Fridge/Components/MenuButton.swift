//
//  FloatingButton.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 8/8/2023.
//

import SwiftUI

struct MenuButton: View {
    
    var body: some View {
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
        }
    }
}

#if DEBUG
struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        MockMenuButton()
    }
}

struct MockMenuButton: View {
    
    var body: some View {
        MenuButton()
    }
}
#endif
