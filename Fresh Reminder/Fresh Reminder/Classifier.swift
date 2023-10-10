//
//  Classifier.swift
//  SeeFood
//
//  Created by Leon Wei on 5/31/21.
//

import CoreML
import Vision
import CoreImage

/// A structure for performing image classification using the "MobileNetV2" (to be changed) model.
///
/// The `Classifier` structure uses the Vision and Core ML frameworks to classify images.
/// It provides a method, `detect(ciImage:)`, that accepts a `CIImage` and populates the `results` property
/// with the most likely classification of that image, based on the "MobileNetV2" (to be changed) model's predictions.
///
struct Classifier {
    
    /// The classification result obtained after running the `detect(ciImage:)` method. It holds the label of the highest-confidence classification for the provided image.
    private(set) var results: String?
    
    /// Detects the content of a given `CIImage` using the MobileNetV2 model.
    ///
    /// The method processes the `CIImage` using the MobileNetV2 model and updates the `results` property
    /// with the most likely classification. If the model or the prediction process fails, the `results` property remains unchanged.
    ///
    /// - Parameter ciImage: The image to classify.
    mutating func detect(ciImage: CIImage) {
        
        // Load the MobileNetV2 model.
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model)
        else {
            return
        }
        
        // Create a Vision request with the loaded model.
        let request = VNCoreMLRequest(model: model)
        
        // Create an image request handler.
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        // Perform the classification request.
        try? handler.perform([request])
        
        // Update the results property with the highest-confidence classification.
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        
        if let firstResult = results.first {
            self.results = firstResult.identifier
        }
    }
}


