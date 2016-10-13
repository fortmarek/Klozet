//
//  ImageSlides.swift
//  Klozet
//
//  Created by Marek Fořt on 10/10/2016.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow
import Alamofire
import SwiftyJSON

class ImageSlides: ImageSlideshow {
    
    var presentDelegate: PresentDelegate?
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(detailStackView: UIStackView, presentDelegate: PresentDelegate) {
        self.init()
        
        self.presentDelegate = presentDelegate
        
        detailStackView.addArrangedSubview(self)
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        var image = UIImage()
        
        Alamofire.request("http://139.59.144.155/klozet/toilet/5").responseJSON {
            response in
            guard
                let data = response.data,
                let imageArray = JSON(data: data)["toilet_images"].array
                else {return}
            guard let imageString = imageArray[0]["image_data"].string else {return}
            print(imageString)
            guard let imageData = NSData(base64Encoded: imageString, options: .ignoreUnknownCharacters) as? Data else {print("fafffil");return}
            image = UIImage(data: imageData)!
            print(imageData)
            
            //guard let image = UIImage(named: "ToiletPic") else {return}
            guard let secondImage = UIImage(named: "Pin") else {return}
            
            print("MATE")
            self.setImageInputs([
                ImageSource(image: image),
                ImageSource(image: secondImage)
                ])
        }
        
        
        
        
        
        
        //imagesSlides.draggingEnabled = false
        circular = false
        pageControlPosition = .hidden
        contentScaleMode = .scaleToFill
        
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageFullScreen))
        addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    
    @objc private func imageFullScreen() {
        
        let fullScreen = FullScreenSlideshowViewController()
        // called when full-screen VC dismissed and used to set the page to our original slideshow
        fullScreen.pageSelected = { page in
            self.setScrollViewPage(page, animated: false)
        }
        
        // set the initial page
        fullScreen.initialImageIndex = scrollViewPage
        // set the inputs
        fullScreen.inputs = images
        slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: self, slideshowController: fullScreen)
        fullScreen.transitioningDelegate = self.slideshowTransitioningDelegate
        presentDelegate?.present(viewController: fullScreen)
        
        fullScreen.closeButton.setImage(UIImage(named: "WhiteCross"), for: .normal)
        fullScreen.view.bringSubview(toFront: fullScreen.closeButton)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


protocol PresentDelegate {
    func present(viewController: UIViewController)
}

extension PresentDelegate where Self: DetailViewController {
    func present(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}


