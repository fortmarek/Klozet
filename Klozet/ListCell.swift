//
//  ListCell.swift
//  Klozet
//
//  Created by Marek Fořt on 08/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class ListCell: UITableViewCell, FilterOpen, DirectionsDelegate, ImageController {
    
    //Background for toilet image
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var mainAddressLabel: UILabel!
    @IBOutlet weak var subaddressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var toiletImageView: UIImageView!
    
    var locationDelegate: UserLocation?
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setCornerRadius(imageBackground, cornerRadius: 10)
        setCornerRadius(toiletImageView, cornerRadius: 10)
        toiletImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //Same background color for image when selected / highlighted
        imageBackground.backgroundColor = .mainBlue
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        imageBackground.backgroundColor = .mainBlue
    }
    
    fileprivate func setCornerRadius(_ view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
    }
    
    func fillCellData(_ toilet: Toilet) {
        setPriceLabel(toilet.price)
        setOpenLabel(toilet)
        setDistanceLabel(toilet.toiletAnnotation.coordinate)
        setImage(toiletId: toilet.toiletId)
        
        mainAddressLabel.text = toilet.title
        subaddressLabel.text = toilet.subtitle
        
    }
    
    fileprivate func setPriceLabel(_ price: String) {
        priceLabel.text = price
        
        
        //If toilet is for free => green color, otherwise set color to orange
        if price == "Free".localized {
            priceLabel.textColor = Colors.greenColor
        }
        else {
            priceLabel.textColor = .mainBlue
        }
 
    }
    
    fileprivate func setOpenLabel(_ toilet: Toilet) {
        //Is toilet open
        if isToiletOpen(toilet) {
            openLabel.text = "Open".localized
            openLabel.sizeToFit()
            openLabel.textColor = Colors.greenColor
        }
        
        //Toilet is not open
        else {
            openLabel.text = "Closed".localized
            openLabel.sizeToFit()
            openLabel.textColor = .mainBlue
        }
 
    }
    
    fileprivate func setDistanceLabel(_ coordinate: CLLocationCoordinate2D) {
        distanceLabel.text = getDistanceString(coordinate)
    }
    
    fileprivate func setImage(toiletId: Int) {
        downloadImage(toiletId: toiletId, imageIndex: 0, isMin: true, completion: {
            image in
            self.toiletImageView.image = image
        })
    }
}

