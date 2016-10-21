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
import AlamofireImage

protocol ImageSlidesDelegate {
    func setNoImageView()
}

class ImageSlides: ImageSlideshow, ImageController, ImageSlidesDelegate {
    
    var presentDelegate: PresentDelegate?
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    
    let activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(toiletId: Int, detailStackView: UIStackView, presentDelegate: PresentDelegate) {
        self.init()
        
        self.presentDelegate = presentDelegate
        
        detailStackView.addArrangedSubview(self)
        heightAnchor.constraint(equalToConstant: 200).isActive = true

        
        setIndicatorView(detailStackView: detailStackView)
        
        circular = false
        pageControlPosition = .hidden
        contentScaleMode = .scaleAspectFill
        
        
        getImages(toiletId: toiletId, completion: {
            imageSources in
            self.setImageInputs(imageSources)
            
            
            
            
                    })
        
        
        
        
        
    }
    
    fileprivate func loadViewToImage(imagesCount: Int) {
        self.activityIndicator.stopAnimating()
        guard imagesCount > 0 else {
            self.setNoImageView()
            return}
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageFullScreen))
        self.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    private func setNoImageView() {
        let noImageView = UIView()
        noImageView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
        noImageView.frame = frame
        addSubview(noImageView)
        
        let noCameraImageView = UIImageView(image: UIImage(named: "NoCamera"))
        noCameraImageView.center = noImageView.center
        addSubview(noCameraImageView)
        
        self.activityIndicator.stopAnimating()
    }
    
    @objc private func imageFullScreen() {
        
        let fullScreen = FullScreenSlideshowViewController()
        
        //Fix for showing wrong image (wrong index), more: https://github.com/zvonicek/ImageSlideshow/issues/67
        fullScreen.slideshow.circular = false
        
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
    
    private func setIndicatorView(detailStackView: UIStackView) {
        activityIndicator.color = Colors.pumpkinColor
        
        guard let detailSuperview = detailStackView.superview else {return}
        detailSuperview.addSubview(activityIndicator)
        detailStackView.layoutIfNeeded()
        activityIndicator.frame.origin.x = frame.size.width / 2 - 10
        activityIndicator.frame.origin.y = detailSuperview.frame.size.height - detailStackView.frame.size.height + 90
        activityIndicator.sizeToFit()
        
        activityIndicator.startAnimating()
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
    
    
    private func getImageCount(toiletId: Int, completion: @escaping(_ imageCount: Int) -> () ) {
        Alamofire.request("http://139.59.144.155/klozet/toilet/5").responseJSON {
            response in
            guard
                let data = response.data,
                let imageCount = JSON(data: data)["image_count"].int
                else {return}
            
            if imageCount == 0 {
                //set no image view
            }
            
            completion(imageCount)
        }
    }
    
    private func donwloadImage(imageIndex: Int, completion: @escaping (_ image: UIImage) -> ()){
        Alamofire.request("http://139.59.144.155/klozet/toilets_img/5/1.jpg").responseImage(completionHandler: {
            response in
            guard let image = response.result.value else {return}
            completion(image)
        })
    }
    
    fileprivate func getImages(toiletId: Int, completion: @escaping (_ images: [ImageSource]) -> () ) {
        
        getImageCount(toiletId: toiletId, completion: {
            imageCount in
            
            var images = [UIImage]()
            
            for i in 1...imageCount {
                self.donwloadImage(imageIndex: i, completion: {
                    image in
                    images.append(image)
                    print(image)
                })
            }
            print("HE|")
        })
        
    }
    
    private func encodedStringToImage(encodedString: String) -> ImageSource? {
        guard
            let imageData = NSData(base64Encoded: encodedString, options: .ignoreUnknownCharacters) as? Data,
            let image = UIImage(data: imageData)
            else {return nil}
        return ImageSource(image: image)
    }
}

