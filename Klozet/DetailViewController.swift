//
//  DetailViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 20/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ShowDelegate, PresentDelegate {
    
    var toilet: Toilet?

    var widthDimension = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Colors.pumpkinColor
        
        let imageBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(uploadImage))
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
    
    func uploadImage(sender: UIBarButtonItem) {
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
    
    func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) else {return}

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        // Show image
        //imageView.image = image
        self.dismiss(animated: true, completion: nil)
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
        
        //BottomAnchor
        detailStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //WidthAnchor
        detailStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        //Axis
        detailStackView.axis = .vertical
        
        detailStackView.distribution = .fill
        
        return detailStackView
    }

}




