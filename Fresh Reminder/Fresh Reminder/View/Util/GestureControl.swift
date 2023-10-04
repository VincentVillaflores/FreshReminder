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
/// Represents different swipe gestures.
///
/// The `Swipe` enum defines possible swipe directions that can be detected or used within a gesture-based user interface. It also includes a `none` case to represent the absence of a swipe.
///
/// - Cases:
///   - left: Represents a swipe gesture moving to the left.
///   - right: Represents a swipe gesture moving to the right.
///   - none: Represents the absence of a swipe or an unrecognised gesture.
enum Swipe {
    case left
    case right
    case none
}

// Function to detect swipe direction
/// Determines the direction of a swipe based on the start and end locations of a drag gesture.
///
/// This function evaluates the `startLocation` and `location` properties of a `DragGesture.Value` instance to determine the direction of the swipe. A minimum distance threshold, `MIN_SWIPE_DIST`, is used to differentiate between actual swipes and minor drag changes.
///
/// - Parameter value: The accumulated value of the drag gesture, which includes the start and current location of the drag.
/// - Returns: The detected swipe direction as an instance of the `Swipe` enum (`left`, `right`, or `none`).
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
