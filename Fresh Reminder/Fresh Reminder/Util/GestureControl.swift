//
//  GestureControl.swift
//  Fresh Reminder
//
//  Created by Matthew Soulsby on 21/8/2023.
//

import Foundation
import SwiftUI

let MIN_SWIPE_DIST: CGFloat = 24

// Gesture types
enum Swipe {
    case left
    case right
    case none
}

// Function to detect swipe direction
func getSwipeDirection(value: DragGesture.Value) -> Swipe {
    var swipeDir: Swipe
    
    switch value.startLocation.x {
    case ..<(value.location.x - MIN_SWIPE_DIST):
        swipeDir = .left
    case (value.location.x + MIN_SWIPE_DIST)...:
        swipeDir = .right
    default:
        swipeDir = .none
    }
    
    return swipeDir
}
