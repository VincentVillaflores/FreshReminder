//
//  ListSpacer.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 22/8/2023.
//

import SwiftUI

// Spacer between list sections (normal spacer would be styled as a list item)
struct ListSpacer: View {
    var body: some View {
        Section(""){}.padding(.bottom, 30)
    }
}

struct ListSpacer_Previews: PreviewProvider {
    static var previews: some View {
        List{
            ListSpacer()
        }
    }
}
