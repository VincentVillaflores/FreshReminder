//
//  CameraView.swift
//  CameraDemo
//
//

import Foundation
import UIKit
import SwiftUI

//to integrate SwiftUI and UIKit
struct CameraView: UIViewControllerRepresentable {
    
    /*
        UIKit provides UIImagePickerController: it is aview controller that
        manages the system interfaces for taking pictures, recording movies,
        and choosing items from the user’s media library
     
     */
    
    typealias UIViewControllerType = UIImagePickerController
    
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.delegate = context.coordinator
        //making use of iPhone's camera
        viewController.sourceType = .camera
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> CameraView.Coordinator {
        return Coordinator(self)
    }
}

extension CameraView {
    /*
       this class Coordinator has the responsibility of
        reacting to pressing "Cancel" and "Use Photo" features of Camera
     */
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        // a delegate that prints Cancel pressed
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            print("Cancel pressed")
        }
        
        //use photo feature
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                //writes photo to your album on iPhone
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
}
