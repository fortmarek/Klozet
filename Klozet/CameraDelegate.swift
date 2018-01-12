//
//  CameraDelegate.swift
//  Klozet
//
//  Created by Marek Fořt on 1/12/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit
import Alamofire 

protocol CameraDelegate {
    var uploadImageType: UploadImageType {get}
}

enum UploadImageType {
    case toilet
    case hours
}

extension CameraDelegate where Self: UIViewController, Self: UINavigationControllerDelegate, Self: UIImagePickerControllerDelegate {
    
    func finishPicking(toilet: Toilet?, info: [String : Any], completion: ((_ image: UIImage,_ toiletId: Int) -> ())?) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        dismiss(animated: true, completion: {
            DispatchQueue.global().async(execute: {
                guard
                    let orientedImage = image.correctlyOrientedImage(),
                    let toilet = toilet
                    else {return}
                self.postImage(image: orientedImage, toiletId: toilet.toiletId)
            })
        })
    }
    
    
    func uploadImage() {
        let alertTitle = uploadImageType == .hours ? "We need a photo to add hours for toilet" : "It's always better with a photo".localized
        let actionSheet = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .mainOrange
        
        let pickPhotoOption = UIAlertAction(title: "Choose image from library".localized, style: .default, handler: {_ in self.selectPhoto()})
        let takePhotoOption = UIAlertAction(title: "Take photo".localized, style: .default, handler: {_ in self.takePhoto()})
        let cancelOption = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {_ in actionSheet.dismiss(animated: true, completion: nil)})
        
        actionSheet.addAction(pickPhotoOption)
        actionSheet.addAction(takePhotoOption)
        actionSheet.addAction(cancelOption)
        
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) else {return}
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func postImage(image: UIImage, toiletId: Int) {
        guard let encodedImage = UIImageJPEGRepresentation(image, 0.9)?.base64EncodedString() else {return}
        let subpath = uploadImageType == .hours ? "hours" : ""
        let path = "http://139.59.144.155/klozet/toilet/\(toiletId)" + subpath
        
        
        _ = Alamofire.request(path, method: .post, parameters: ["encoded_image" : encodedImage])
    }
}
