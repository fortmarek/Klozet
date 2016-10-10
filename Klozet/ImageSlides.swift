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
        
        guard let image = UIImage(named: "ToiletPic") else {return}
        guard let secondImage = UIImage(named: "Pin") else {return}
        
        
        setImageInputs([
            ImageSource(image: image),
            ImageSource(image: secondImage)
            ])
        
        
        
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


