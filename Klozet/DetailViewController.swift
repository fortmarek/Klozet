//
//  DetailViewController.swift
//  Klozet
//
//  Created by Marek Fořt on 20/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit
import ImageSlideshow

class DetailViewController: UIViewController, PresentDelegate {
    
    var toilet: Toilet?
    
    var widthDimension = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Colors.pumpkinColor
        
        //Main Stack View
        let detailStackView = setDetailStackView()
        automaticallyAdjustsScrollViewInsets = false
        
        
        let imagesSlides = ImageSlideshow()
        detailStackView.addArrangedSubview(imagesSlides)
        imagesSlides.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
        guard let image = UIImage(named: "ToiletPic") else {return}
        guard let secondImage = UIImage(named: "Pin") else {return}
        

        imagesSlides.setImageInputs([
            ImageSource(image: image),
            ImageSource(image: secondImage)
            ])
        
        
        
        //imagesSlides.draggingEnabled = false
        imagesSlides.circular = false
        imagesSlides.pageControlPosition = .hidden
        imagesSlides.contentScaleMode = .scaleToFill
        

        
        //TableView
        let tableView = DetailTableView()
        tableView.delegate = self
        tableView.dataSource = self
        detailStackView.addArrangedSubview(tableView)
        
        
        guard let toilet = toilet else {return}
        _ = MapInfoView(detailStackView: detailStackView, toilet: toilet, presentDelegate: self)
        _ = DetailMapStack(detailStackView: detailStackView, toilet: toilet, presentDelegate: self)
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
