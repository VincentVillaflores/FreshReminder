//
//  ImagePicker.swift
//  SeeFood
//
//  Created by Leon Wei on 5/31/21.
//

import SwiftUI
import UIKit


/// A SwiftUI view that wraps a UIKit-based image picker.
///
/// `ImagePicker` is a bridge between SwiftUI and UIKit, allowing the use of a `UIImagePickerController` within a SwiftUI-based application.
/// This struct makes it possible to present an image picker to the user, choose an image from the photo library or camera, and then passes the prediction back to the NewItemView.
///
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var uiImage: UIImage?
    @Binding var isPresenting: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    
    /// Creates a new `UIImagePickerController` instance and sets its properties and delegate.
    ///
    /// - Parameter context: A context that provides information for creating the view controller.
    /// - Returns: A configured instance of `UIImagePickerController`.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    /// Updates the provided `UIImagePickerController` instance in response to changes in the SwiftUI view hierarchy.
    /// No state changes are required so this function is empty.
    ///
    /// - Parameters:
    ///   - uiViewController: The `UIImagePickerController` to update.
    ///   - context: A context that provides information for updating the view controller.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    typealias UIViewControllerType = UIImagePickerController
        
    /// Creates an instance of the coordinator class for the `UIImagePickerController`.
    ///
    /// - Returns: A new `Coordinator` instance.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// A coordinator class to handle delegate callbacks from the `UIImagePickerController`.
    ///
    /// The `Coordinator` acts as a bridge for the delegate methods of `UIImagePickerController`, allowing the image picker to communicate back to the `ImagePicker` struct.
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePicker
        
        /// Handles the image picker's selection of an image.
        ///
        /// - Parameters:
        ///   - picker: The active `UIImagePickerController` instance.
        ///   - info: A dictionary containing information about the selected image.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.uiImage = info[.originalImage] as? UIImage
            parent.isPresenting = false
        }
        
        /// Handles the cancellation of the image picker.
        ///
        /// - Parameter picker: The active `UIImagePickerController` instance.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresenting = false
        }
        
        /// Initializes a new coordinator for the provided `ImagePicker` instance.
        ///
        /// - Parameter imagePicker: The parent `ImagePicker` for which this coordinator was created.
        init(_ imagePicker: ImagePicker) {
            self.parent = imagePicker
        }
    }
}
