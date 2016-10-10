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
    
    let imagesSlides = ImageSlideshow()
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    
    var toilet: Toilet?

    var widthDimension = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = Colors.pumpkinColor
        
        //Main Stack View
        let detailStackView = setDetailStackView()
        automaticallyAdjustsScrollViewInsets = false
        
        
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
        
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageFullScreen))
        imagesSlides.addGestureRecognizer(imageGestureRecognizer)

        
        //TableView
        let tableView = DetailTableView()
        tableView.delegate = self
        tableView.dataSource = self
        detailStackView.addArrangedSubview(tableView)
        
        
        guard let toilet = toilet else {return}
        _ = MapInfoView(detailStackView: detailStackView, toilet: toilet, presentDelegate: self)
        _ = DetailMapStack(detailStackView: detailStackView, toilet: toilet, presentDelegate: self)
    }
    
    func imageFullScreen() {
        let fullScreen = FullScreenSlideshowViewController()
        // called when full-screen VC dismissed and used to set the page to our original slideshow
        fullScreen.pageSelected = { page in
            self.imagesSlides.setScrollViewPage(page, animated: false)
        }
        
        // set the initial page
        fullScreen.initialImageIndex = imagesSlides.scrollViewPage
        // set the inputs
        fullScreen.inputs = imagesSlides.images
        self.slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: imagesSlides, slideshowController: fullScreen)
        fullScreen.transitioningDelegate = self.slideshowTransitioningDelegate
        self.present(fullScreen, animated: true, completion: nil)
        
        fullScreen.closeButton.setImage(UIImage(named: "WhiteCross"), for: .normal)
        fullScreen.view.bringSubview(toFront: fullScreen.closeButton)
        



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
