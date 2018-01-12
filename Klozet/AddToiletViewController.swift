//
//  AddToiletViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 1/5/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddToiletViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, CameraDelegate, UINavigationControllerDelegate {
    
    var toilet: Toilet = Toilet(title: "", subtitle: "", coordinate: CLLocationCoordinate2D(), openTimes: [], price: "", toiletId: 0)
    var tapGestureRecognizer: UITapGestureRecognizer?
    var addToiletCollectionView: UICollectionView?
    var uploadImageType: UploadImageType = .toilet
    var toiletImage: UIImage?
    var hoursImage: UIImage? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Toilet"
        
        view.backgroundColor = .white

        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBarButtonTapped))
        let cancelAttributes: [NSAttributedStringKey : Any] = [.font : UIFont.systemFont(ofSize: 17, weight: .medium), .foregroundColor : UIColor.mainOrange]
        cancelBarButtonItem.setTitleTextAttributes(cancelAttributes, for: .normal)
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        
        let addToiletCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        addToiletCollectionView.dataSource = self
        addToiletCollectionView.delegate = self
        addToiletCollectionView.backgroundColor = .white
        addToiletCollectionView.register(MapCollectionViewCell.self, forCellWithReuseIdentifier: "mapCell")
        addToiletCollectionView.register(LocationDetailCollectionViewCell.self, forCellWithReuseIdentifier: "locationDetails")
        addToiletCollectionView.register(AddToiletCollectionViewCell.self, forCellWithReuseIdentifier: "addToiletCell")
        view.addSubview(addToiletCollectionView)
        addToiletCollectionView.heightAnchor.constraint(equalToConstant: 435).isActive = true
        addToiletCollectionView.pinToViewHorizontally(view)
        addToiletCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.addToiletCollectionView = addToiletCollectionView

        
        let proxyView = UIView()
        view.addSubview(proxyView)
        proxyView.pinToViewHorizontally(view)
        proxyView.topAnchor.constraint(equalTo: addToiletCollectionView.bottomAnchor).isActive = true
        proxyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        let saveButton = UIButton()
        saveButton.backgroundColor = .mainOrange
        saveButton.setTitle("Add Toilet", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.addSubview(saveButton)
        saveButton.centerInView(proxyView)
        saveButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        saveButton.layer.cornerRadius = 22
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        addToiletCollectionView?.reloadItems(at: [IndexPath(row: 0, section: 0)])
    
    }
    
    @objc private func cancelBarButtonTapped() {
        
        //TODO: Alert when some info filled in?
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        finishPicking(toilet: toilet, info: info, completion: nil)
    }
}

extension AddToiletViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        switch indexPath.row {
        case 0:
            let mapCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mapCell", for: indexPath) as! MapCollectionViewCell
            mapCell.toilet = toilet
            mapCell.centerToToilet()
            cell = mapCell
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationDetails", for: indexPath) as! LocationDetailCollectionViewCell
        case 2...3:
            let addToiletCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addToiletCell", for: indexPath) as! AddToiletCollectionViewCell
            addToiletCell.tappableCellView.cellViewLabel.text = indexPath.row == 2 ? "Add photo of hours" : "Add photo of toilet"
            cell = addToiletCell
        default:
            cell = UICollectionViewCell()
        }
        
        return cell
    }
    
    
}

extension AddToiletViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
        switch indexPath.row {
        case 0:
            let addMapViewController = AddMapToiletViewController()
            addMapViewController.toilet = toilet
            navigationController?.pushViewController(addMapViewController, animated: true)
        case 2:
            uploadImageType = .hours
            uploadImage()
        case 3:
            uploadImageType = .toilet
            uploadImage()
        default: break
        }
    }
}

extension AddToiletViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat
        switch indexPath.row {
        case 0: height = 223
        case 1: height = 105
        case 2...3: height = 53
        default: height = 100
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

