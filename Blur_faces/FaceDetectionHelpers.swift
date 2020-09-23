//
//  FaceDetectionHelpers.swift
//  Blur_faces
//
//  Created by M'haimdat omar on 21-09-2020.
//

import Vision
import UIKit

enum Faces: String {
    case zero
    case one
    case multiple
    var description: String {
        get {
            return self.rawValue
        }
    }
}

// MARK: - Face Detection Class
/// A helper class to process face detection
/// using Apple's API
class AppleFaceDetection {
    
    // MARK: - Function that calculate the number of faces in the image
    /**
    Get the number of faces in an image.
     - Parameters:
        - image : image to process of type *UIImage*.
        - completion: A closure which returns the number of faces.
     - Returns: No return value.
    */
    static func GetNumberOfFaces(image: UIImage, completion: @escaping (_ count: Int?) -> ()) {
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            if let results = req.results {
                completion(results.count)
            }
        }
        
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
    }
    
    
    static func GetTheFaces(image: UIImage, completion: @escaping (Faces?) -> ()) {
        
        var faces: Faces?
        
        self.GetNumberOfFaces(image: image) { (count) in
            if let numberOfFaces = count {
                if numberOfFaces == 0 {
                    faces = Faces.zero
                    completion(faces)
                } else if numberOfFaces > 1 {
                    faces = Faces.multiple
                    completion(faces)
                } else if numberOfFaces == 1 {
                    faces = Faces.one
                    completion(faces)
                }
            }
        }
    }
    
    static func GetFaceBoundingBoxes(image: UIImage, completion: @escaping ([Any]?) -> ()) {
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            if let results = req.results {
                completion(results)
            }
        }
        
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
    }
    
    
}
