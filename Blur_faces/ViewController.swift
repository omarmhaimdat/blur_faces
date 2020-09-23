//
//  ViewController.swift
//  Blur_faces
//
//  Created by M'haimdat omar on 21-09-2020.
//

import UIKit
import Vision

let screenWidth = UIScreen.main.bounds.width

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let logo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "face_detection").resized(newSize: CGSize(width: screenWidth - 120, height: screenWidth - 120)))
        let tintedImage = image.image?.withRenderingMode(.alwaysTemplate)
        image.image = tintedImage
        image.tintColor = .label
        image.translatesAutoresizingMaskIntoConstraints = false
       return image
    }()
    
    lazy var openCameraBtn : CustomButton = {
       let btn = CustomButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Camera", for: .normal)
        let icon = UIImage(named: "camera")?.resized(newSize: CGSize(width: 45, height: 45))
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = .label
        btn.addTarget(self, action: #selector(buttonToOpenCamera(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var openToUploadBtn : CustomButton = {
       let btn = CustomButton()
        btn.addTarget(self, action: #selector(buttonToUpload(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addButtonsToSubview()
        setupView()
    }
    
    fileprivate func addButtonsToSubview() {
        view.addSubview(logo)
        view.addSubview(openCameraBtn)
        view.addSubview(openToUploadBtn)
    }
    
    fileprivate func setupView() {
        
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        
        openCameraBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openCameraBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        openCameraBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        openCameraBtn.bottomAnchor.constraint(equalTo: openToUploadBtn.topAnchor, constant: -40).isActive = true
        
        openToUploadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openToUploadBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        openToUploadBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        openToUploadBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            
        if let image = info[.editedImage] as? UIImage {
            
            let outputVC = FaceBoxViewController()
            outputVC.modalPresentationStyle = .fullScreen
            let newImage = image.resized(newSize: CGSize(width: 375, height: 375))
            outputVC.inputImage.image = newImage
            dismiss(animated: true, completion: nil)
            self.present(outputVC, animated: true, completion: nil)
            
        }
    }
    
    @objc func buttonToUpload(_ sender: CustomButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func buttonToOpenCamera(_ sender: CustomButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

}


