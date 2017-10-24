//
//  DetailViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 20/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit
import Alamofire


class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ShowDelegate, PresentDelegate, CameraDelegate {
    
    var toilet: Toilet?

    var widthDimension = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .mainBlue
        
        let imageBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(imageButtonTapped))
        
        navigationItem.rightBarButtonItem = imageBarButtonItem
        
        //Main Stack View
        let detailStackView = setDetailStackView()
        automaticallyAdjustsScrollViewInsets = false
        
        guard let toilet = toilet else {return}
        
        _ = ImageSlides(toiletId: toilet.toiletId, detailStackView: detailStackView, presentDelegate: self)
        
        //TableView
        let tableView = DetailTableView()
        tableView.delegate = self
        tableView.dataSource = self
        detailStackView.addArrangedSubview(tableView)
        
        _ = MapInfoView(detailStackView: detailStackView, toilet: toilet, showDelegate: self)
        _ = DetailMapStack(detailStackView: detailStackView, toilet: toilet, showDelegate: self)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setDetailStackView() -> UIStackView {
        let detailStackView = UIStackView()
        view.layoutIfNeeded()
        view.addSubview(detailStackView)
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //TopAnchor to bottom of navigationBar (by adding its x origin and height)
        guard let navigationController = navigationController else {return UIStackView()}
        let topMainAnchor = navigationController.navigationBar.frame.height + navigationController.navigationBar.frame.origin.x
        detailStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: topMainAnchor).isActive = true
        
        detailStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailStackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailStackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        //Axis
        detailStackView.axis = .vertical
        
        detailStackView.distribution = .fill
        
        return detailStackView
    }
    
    func imageButtonTapped() {
        uploadImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        dismiss(animated: true, completion: {
            DispatchQueue.global().async(execute: {
                guard
                    let orientedImage = image.correctlyOrientedImage(),
                    let toilet = self.toilet
                else {return}
                self.postImage(image: orientedImage, toiletId: toilet.toiletId)
            })
        })
        
        
    }

}

protocol CameraDelegate {
    
}


extension CameraDelegate where Self: UIViewController, Self: UINavigationControllerDelegate, Self: UIImagePickerControllerDelegate {
    
    
    fileprivate func uploadImage() {
        let actionSheet = UIAlertController(title: "It's always better with a photo".localized, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .mainBlue
        
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
    
    fileprivate func postImage(image: UIImage, toiletId: Int) {
        guard let encodedImage = UIImageJPEGRepresentation(image, 0.9)?.base64EncodedString() else {return}
        let path = "http://139.59.144.155/klozet/toilet/\(toiletId)"

        _ = Alamofire.request(path, method: .post, parameters: ["encoded_image" : encodedImage])
    }
    

}

extension UIImage {
    func correctlyOrientedImage() -> UIImage? {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}

