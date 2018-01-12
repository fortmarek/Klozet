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
    
    var uploadImageType: UploadImageType = .toilet
    var toilet: Toilet?

    var widthDimension = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let imageBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(imageButtonTapped))
        
        navigationItem.rightBarButtonItem = imageBarButtonItem
        
        //Main Stack View
        let detailStackView = setDetailStackView()
        
        guard let toilet = toilet else {return}
        
        _ = ImageSlides(toiletId: toilet.toiletId, detailStackView: detailStackView, presentDelegate: self)
        
        //TableView
        let tableView = DetailTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        detailStackView.addArrangedSubview(tableView)
        
        _ = MapInfoView(detailStackView: detailStackView, toilet: toilet, showDelegate: self)
        _ = DetailMapStack(detailStackView: detailStackView, toilet: toilet, showDelegate: self)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setDetailStackView() -> UIStackView {
        let detailStackView = UIStackView()
        view.addSubview(detailStackView)
        detailStackView.translatesAutoresizingMaskIntoConstraints = false
        detailStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        detailStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        detailStackView.pinToViewHorizontally(view)
        
        //Axis
        detailStackView.axis = .vertical
        
        detailStackView.distribution = .fill
        
        return detailStackView
    }
    
    @objc func imageButtonTapped() {
        uploadImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        finishPicking(toilet: toilet, info: info, completion: { [weak self] image, toiletId in
            self?.postImage(image: image, toiletId: toiletId)
        })
    }

}

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
    
    fileprivate func postImage(image: UIImage, toiletId: Int) {
        guard let encodedImage = UIImageJPEGRepresentation(image, 0.9)?.base64EncodedString() else {return}
        let subpath = uploadImageType == .hours ? "hours" : ""
        let path = "http://139.59.144.155/klozet/toilet/\(toiletId)" + subpath
        

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

