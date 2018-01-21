//
//  DetailViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 20/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ShowDelegate, PresentDelegate, CameraDelegate, ImagePostable {
    
    var uploadImageType: UploadImageType = .toilet
    var toilet: Toilet?

    var widthDimension = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let editBarButtonItem = UIBarButtonItem.init(image: UIImage(asset: Asset.editIcon), style: .plain, target: self, action: #selector(editBarButtonTapped))
        navigationItem.rightBarButtonItem = editBarButtonItem
        
        //Main Stack View
        let detailStackView = setDetailStackView()
        
        guard let toilet = toilet else {return}
        
        _ = ImageSlides(imageCount: toilet.imageCount, toiletId: toilet.toiletId, detailStackView: detailStackView, presentDelegate: self)
        
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
    
    @objc private func editBarButtonTapped() {
        let editToiletViewController = EditToiletViewController()
        editToiletViewController.toilet.toiletId = toilet?.toiletId ?? 0
        let editNavigationController = UINavigationController(rootViewController: editToiletViewController)
        navigationController?.present(editNavigationController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        finishPicking(toilet: toilet, info: info, completion: { [weak self] image, toiletId in
            guard let uploadImageType = self?.uploadImageType else {return}
            self?.postImage(image: image, toiletId: toiletId, uploadImageType: uploadImageType)
        })
    }

}

