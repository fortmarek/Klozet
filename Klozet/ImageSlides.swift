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


class ImageSlides: ImageSlideshow, ImageController {
    
    var presentDelegate: PresentDelegate?
    var slideShowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    
    let activityIndicatorView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(imageCount: Int, toiletId: Int, detailStackView: UIStackView, presentDelegate: PresentDelegate) {
        self.init()
        
        self.presentDelegate = presentDelegate
        
        detailStackView.addArrangedSubview(self)
        heightAnchor.constraint(equalToConstant: 200).isActive = true

        
        setIndicatorView(detailStackView: detailStackView)
        
        circular = false
        pageControlPosition = .hidden
        contentScaleMode = .scaleAspectFill
        
        
        getImages(toiletId: toiletId, imageCount: imageCount, completion: {
            imageSources in
            
            self.loadViewToImage(imagesCount: imageSources.count)
            self.setImageInputs(imageSources)
    
        })
        
    }
    
    fileprivate func loadViewToImage(imagesCount: Int) {
        self.activityIndicatorView.stopAnimating()
        guard imagesCount > 0 else {
            self.setNoImageView()
            return}
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageFullScreen))
        self.addGestureRecognizer(imageGestureRecognizer)
        
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
        fullScreen.initialPage = scrollViewPage
        // set the inputs
        fullScreen.inputs = images
        slideShowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: self, slideshowController: fullScreen)
        fullScreen.transitioningDelegate = self.slideShowTransitioningDelegate
        presentDelegate?.present(viewController: fullScreen)
        
        fullScreen.closeButton.setImage(UIImage(named: "WhiteCross"), for: .normal)
        fullScreen.view.bringSubview(toFront: fullScreen.closeButton)
    }
    
    private func setIndicatorView(detailStackView: UIStackView) {
        activityIndicatorView.color = .mainOrange
        
        guard let detailSuperview = detailStackView.superview else {return}
        detailSuperview.addSubview(activityIndicatorView)
        detailStackView.layoutIfNeeded()
        activityIndicatorView.frame.origin.x = frame.size.width / 2 - 10
        activityIndicatorView.frame.origin.y = detailSuperview.frame.size.height - detailStackView.frame.size.height + 90
        activityIndicatorView.sizeToFit()
        
        activityIndicatorView.startAnimating()
    }
    
    private func setNoImageView() {
        let noImageView = UIView()
        noImageView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
        noImageView.frame = frame
        addSubview(noImageView)
        
        let noCameraImageView = UIImageView(image: UIImage(asset: Asset.noCamera))
        addSubview(noCameraImageView)
        noCameraImageView.centerInView(self)
        
        self.activityIndicatorView.stopAnimating()
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

    func downloadImage(toiletId: Int, imageIndex: Int, isMin: Bool, completion: @escaping (_ image: UIImage) -> ()) {
        let path = "http://139.59.144.155/klozet/toilets_img/\(toiletId)/\(imageIndex)"
        let suffix = isMin ? "_min.jpg" : ".jpg"
        
        let wholePath = path + suffix
    
        Alamofire.request(wholePath).responseImage(completionHandler: {
            response in
            guard let image = response.result.value else {return}
            
            completion(image)
        })
    }
    
    private func donwloadImages(toiletId: Int, imageCount: Int, completion: @escaping (_ images: [ImageSource]) -> ()){
        
        var images = [ImageSource]()
        
        guard imageCount > 0 else {
            completion([])
            return
        }
        
        for i in 0...(imageCount - 1) {
            self.downloadImage(toiletId: toiletId, imageIndex: i, isMin: false, completion: {
                image in
                let imageSource = ImageSource(image: image)
                images.append(imageSource)

                if images.count == imageCount {
                    completion(images)
                }
            })
        }
        
    }
    
    fileprivate func getImages(toiletId: Int, imageCount: Int, completion: @escaping (_ images: [ImageSource]) -> () ) {
        donwloadImages(toiletId: toiletId, imageCount: imageCount, completion: {
            images in
            completion(images)
        })
    }
    
    private func encodedStringToImage(encodedString: String) -> ImageSource? {
        guard
            let imageData = NSData(base64Encoded: encodedString, options: .ignoreUnknownCharacters) as Data?,
            let image = UIImage(data: imageData)
            else {return nil}
        return ImageSource(image: image)
    }
}

