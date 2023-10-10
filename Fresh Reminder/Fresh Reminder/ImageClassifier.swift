//
//  ImageClassification.swift
//  SeeFood
//
//  Created by Leon Wei on 5/31/21.
//

import SwiftUI

/// A class responsible for image classification that provides observable updates.
///
/// `ImageClassifier` is a wrapper around the `Classifier` structure, designed to work within a SwiftUI environment.
/// It uses the `Classifier` to perform image classification and updates its subscribers whenever a classification is completed.
/// The primary use-case is to bind this class's properties to SwiftUI views, allowing for reactive UI updates in response to classification tasks.
///
class ImageClassifier: ObservableObject {
    
    /// An instance of the `Classifier` structure to handle the core classification tasks.
    @Published private var classifier = Classifier()
    
    /// The classification result. Returns the label of the highest-confidence classification for a processed image.
    var imageClass: String? {
        classifier.results
    }
        
    /// Detects the content of a given `UIImage` and updates the `imageClass` property accordingly.
    ///
    /// This method converts the `UIImage` into a `CIImage` format which is then passed to the internal classifier for processing.
    /// Upon successful classification, subscribers will be notified, and the `imageClass` property will reflect the latest results.
    ///
    /// - Parameter uiImage: The UIImage to classify.
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
    }
        
}
