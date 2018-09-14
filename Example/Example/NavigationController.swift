//
//  NavigationController.swift
//  Example
//
//  Created by Colby L Williams on 9/14/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import UIKit
import AzureVision

class NavigationController: UINavigationController {
    
    var imagePicker: UIImagePickerController!
    
    func takePicture() {
        
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.delegate = self
        }
        
        present(imagePicker, animated: true) {
            print("present")
        }
    }
}


extension NavigationController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        for i in info { print("key: \(i.key.rawValue) \t\t\t value: \(i.value)") }
        
        let image: UIImage = (info[.originalImage] as! UIImage).cropToSquare()

        
        
        print(image)

        //AzureVisionClient.shared.analyze(image: image, visualFeatures: [.adult, .categories, .color, .description, .faces, .imageType, .tags]) { response in
        //AzureVisionClient.shared.describe(image: image) { response in
        AzureVisionClient.shared.ocr(image: image) { response in
            
            //response.printResult()
            response.printResponseData()
            
            if let result = response.resource {

                print("yay!")
                
                DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension NavigationController: UINavigationControllerDelegate { }


extension UIImage {
    
    func cropToSquare() -> UIImage {
        
        let refWidth = CGFloat((self.cgImage!.width))
        let refHeight = CGFloat((self.cgImage!.height))
        let cropSize = refWidth > refHeight ? refHeight : refWidth
        
        let x = (refWidth - cropSize) / 2.0
        let y = (refHeight - cropSize) / 2.0
        
        let cropRect = CGRect(x: x, y: y, width: cropSize, height: cropSize)
        let imageRef = self.cgImage?.cropping(to: cropRect)
        let cropped = UIImage(cgImage: imageRef!, scale: 0.0, orientation: self.imageOrientation)
        
        return cropped
    }
}
