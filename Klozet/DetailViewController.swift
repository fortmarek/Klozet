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
        
        navigationController?.navigationBar.tintColor = Colors.pumpkinColor
        
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
                print(image.imageOrientation.rawValue)
                guard let imageInCg = image.cgImage else {return}
                let orientedImage = UIImage(cgImage: imageInCg, scale: 1, orientation: .up)
                print(orientedImage.imageOrientation.rawValue)
                self.postImage(image: orientedImage)
            })
        })
        
        
    }

}

protocol CameraDelegate {
    
}


extension CameraDelegate where Self: UIViewController, Self: UINavigationControllerDelegate, Self: UIImagePickerControllerDelegate {
    
    
    fileprivate func uploadImage() {
        let actionSheet = UIAlertController(title: "S fotkou je to vždycky lepší".localized, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = Colors.pumpkinColor
        
        let pickPhotoOption = UIAlertAction(title: "Vybrat z fotogalerie".localized, style: .default, handler: {_ in self.selectPhoto()})
        let takePhotoOption = UIAlertAction(title: "Pořídit fotku".localized, style: .default, handler: {_ in self.takePhoto()})
        let cancelOption = UIAlertAction(title: "Zrušit".localized, style: .cancel, handler: {_ in actionSheet.dismiss(animated: true, completion: nil)})
        
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
    
    fileprivate func postImage(image: UIImage) {
        guard let encodedImage = UIImageJPEGRepresentation(image, 0.9)?.base64EncodedString() else {return}
        _ = Alamofire.request("http://139.59.144.155/klozet/toilet/5", method: .post, parameters: ["encoded_image" : encodedImage])
    }
    
    
    
    
    
}


