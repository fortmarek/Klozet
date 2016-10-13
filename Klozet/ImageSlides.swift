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

class ImageSlides: ImageSlideshow, ImageController {
    
    var presentDelegate: PresentDelegate?
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(toiletId: Int, detailStackView: UIStackView, presentDelegate: PresentDelegate) {
        self.init()
        
        self.presentDelegate = presentDelegate
        
        detailStackView.addArrangedSubview(self)
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        getImages(toiletId: toiletId, completion: {
            imageSources in
            self.setImageInputs(imageSources)
        })
        
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


protocol ImageController {
    
}

extension ImageController {
    func getImages(toiletId: Int, completion: @escaping (_ images: [ImageSource]) -> () ) {
        Alamofire.request("http://139.59.144.155/klozet/toilet/5").responseJSON {
            response in
            
            guard
                let data = response.data,
                let imageArray = JSON(data: data)["toilet_images"].array
            else {return}
            
            var decodedImages = [ImageSource]()
            for imageDict in imageArray {
                
                guard
                    let encodedImageString = imageDict["image_data"].string,
                    let decodedImage = self.encodedStringToImage(encodedString: encodedImageString)
                else {return}
                decodedImages.append(decodedImage)
            }
            
            completion(decodedImages)
            
        }
    }
    
    private func encodedStringToImage(encodedString: String) -> ImageSource? {
        guard
            let imageData = NSData(base64Encoded: encodedString, options: .ignoreUnknownCharacters) as? Data,
            let image = UIImage(data: imageData)
            else {return nil}
        return ImageSource(image: image)
    }
}

