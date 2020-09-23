//
//  CustomButton.swift
//  Blur_faces
//
//  Created by M'haimdat omar on 21-09-2020.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layer.borderWidth = 2
        layer.backgroundColor = UIColor.systemBackground.cgColor
        setTitleColor(.label, for: .normal)
        titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 30
        setTitle("Upload", for: .normal)
        let icon = UIImage(named: "upload")?.resized(newSize: CGSize(width: 45, height: 45))
        self.setImage( icon, for: .normal)
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = .label
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 100)
        self.layoutIfNeeded()
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        contentHorizontalAlignment = .center
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowRadius = 10
        layer.masksToBounds = true
        clipsToBounds = false
        titleEdgeInsets.left = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    
    func resized(newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

