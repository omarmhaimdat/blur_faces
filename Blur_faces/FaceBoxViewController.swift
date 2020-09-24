//
//  FaceBoxViewController.swift
//  Blur_faces
//
//  Created by M'haimdat omar on 21-09-2020.
//

import UIKit
import Vision

class FaceBoxViewController: UIViewController {
    
    var blurredImage: UIImage?
    var originalImage: UIImage?
    
    lazy var inputImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.clipsToBounds = false
        return image
    }()
    
    lazy var saveImage: CustomButton = {
        let button = CustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToSaveImage(_:)), for: .touchUpInside)
        button.setTitle("Download", for: .normal)
        let icon = UIImage(systemName: "square.and.arrow.down")?.resized(newSize: CGSize(width: 35, height: 35))
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        return button
    }()
    
    lazy var dissmissButton: CustomButton = {
        let button = CustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToDissmiss(_:)), for: .touchUpInside)
        button.setTitle("Dismiss", for: .normal)
        let icon = UIImage(systemName: "xmark.circle")?.resized(newSize: CGSize(width: 35, height: 35))
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drawBoundingBox()
    }
    
    func addSubviews() {
        view.addSubview(inputImage)
        view.addSubview(saveImage)
        view.addSubview(dissmissButton)
    }
    
    func setupLayout() {
        inputImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        inputImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputImage.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        inputImage.heightAnchor.constraint(equalToConstant: (inputImage.image?.size.height)!*view.frame.width/(inputImage.image?.size.width)!).isActive = true
        inputImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        saveImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        saveImage.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        saveImage.bottomAnchor.constraint(equalTo: dissmissButton.topAnchor, constant: -40).isActive = true
        
        dissmissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dissmissButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dissmissButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        dissmissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    func drawBoundingBox() {
        AppleFaceDetection.GetFaceBoundingBoxes(image: self.inputImage.image!) { (resutls) in
            resutls?.forEach({ (result) in
                DispatchQueue.main.async {
                    guard let faceObservation = result as? VNFaceObservation else { return }
                    
                    let scaledHeight = ((self.inputImage.image?.size.width)! ) / (self.inputImage.image?.size.width)! * (self.inputImage.image?.size.height)!
                    
                    let x = ((self.inputImage.image?.size.width)! ) * faceObservation.boundingBox.origin.x
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let y = scaledHeight * (1 -  faceObservation.boundingBox.origin.y) - height
                    let width = ((self.inputImage.image?.size.width)! ) * faceObservation.boundingBox.width
                    
                    self.originalImage = self.inputImage.image
                    
                    let bounds = CGRect(x: x, y: y, width: width, height: height)
                    print(bounds)
                    if let originalImage = self.inputImage.image {
                        if let resultImage = originalImage.applyBlur(rect: bounds, withRadius: 80.0) {
                            self.inputImage.image = resultImage
                            print(resultImage)
                            self.blurredImage = resultImage
                        }
                    }
                    
                   
                   print(faceObservation.boundingBox)
                }
            })
        }
    }
    
    @objc func buttonToDissmiss(_ sender: CustomButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonToSaveImage(_ sender: CustomButton) {
        UIImageWriteToSavedPhotosAlbum(self.blurredImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            triggerAlert(title: "Error while saving", message: error.localizedDescription)
        } else {
            triggerAlert(title: "Saved", message: "You can find your image in the photo library")
        }
    }
    
    func triggerAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension UIImage {
    
    func getImageFromRect(rect: CGRect) -> UIImage? {
        if let cg = self.cgImage,
           let mySubimage = cg.cropping(to: rect) {
            return UIImage(cgImage: mySubimage)
        }
        return nil
    }
    
    // https://stackoverflow.com/a/48110726/9253314
    func croppedImage(inRect rect: CGRect) -> UIImage? {
        let rad: (Double) -> CGFloat = { deg in
            return CGFloat(deg / 180.0 * .pi)
        }
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            let rotation = CGAffineTransform(rotationAngle: rad(90))
            rectTransform = rotation.translatedBy(x: 0, y: -size.height)
        case .right:
            let rotation = CGAffineTransform(rotationAngle: rad(-90))
            rectTransform = rotation.translatedBy(x: -size.width, y: 0)
        case .down:
            let rotation = CGAffineTransform(rotationAngle: rad(-180))
            rectTransform = rotation.translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = .identity
        }
        rectTransform = rectTransform.scaledBy(x: scale, y: scale)
        let transformedRect = rect.applying(rectTransform)
        let imageRef = cgImage!.cropping(to: transformedRect)!
        let result = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        return result
    }
    
    // https://stackoverflow.com/a/34105273/9253314
    func blurImage(withRadius radius: Double) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        let originalOrientation = self.imageOrientation
        let originalScale = self.scale
        
        let filter = CIFilter(name: "CIPixellate")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: "inputScale")
        let outputImage = filter?.outputImage

        var cgImage: CGImage?

        if let asd = outputImage {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }

        if let cgImageA = cgImage {
            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
        }

        return nil
    }

    func drawImageInRect(inputImage: UIImage, inRect imageRect: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        inputImage.draw(in: imageRect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }

    func applyBlur(rect: CGRect, withRadius radius: Double) -> UIImage? {
        if let subImage = self.croppedImage(inRect: rect),
            let blurredZone = subImage.blurImage(withRadius: radius) {
            return self.drawImageInRect(inputImage: blurredZone, inRect: rect)
        }
        return nil
    }

}

