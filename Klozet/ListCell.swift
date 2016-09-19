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

class ListCell: UITableViewCell, FilterOpen, DirectionsDelegate {
    
    //Background for toilet image
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var mainAddressLabel: UILabel!
    @IBOutlet weak var subaddressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var locationDelegate: UserLocation?
    
    let greenColor = UIColor(red: 0.00, green: 0.75, blue: 0.00, alpha: 1.0)

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setCornerRadius(imageBackground, cornerRadius: 10)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        imageBackground.backgroundColor = Colors.pumpkinColor
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        imageBackground.backgroundColor = Colors.pumpkinColor
    }
    
    fileprivate func setCornerRadius(_ view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
    }
    
    func fillCellData(_ toilet: Toilet) {
        setPriceLabel(toilet.price)
        setOpenLabel(toilet)
        setDistanceLabel(toilet.coordinate)
        
        mainAddressLabel.text = toilet.title
        subaddressLabel.text = toilet.subtitle
        
    }
    
    fileprivate func setPriceLabel(_ price: String) {
        priceLabel.text = price
        
        
        //If toilet is for free => green color, otherwise set color to orange
        if price == "Zdarma" {
            priceLabel.textColor = greenColor
        }
        else {
            priceLabel.textColor = Colors.pumpkinColor
        }
 
    }
    
    fileprivate func setOpenLabel(_ toilet: Toilet) {
        //Is toilet open
        if isToiletOpen(toilet) {
            openLabel.text = "Otevřeno"
            openLabel.sizeToFit()
            openLabel.textColor = greenColor
        }
        
        //Toilet is not open
        else {
            openLabel.text = "Zavřeno"
            openLabel.sizeToFit()
            openLabel.textColor = Colors.pumpkinColor
        }
 
    }
    
    fileprivate func setDistanceLabel(_ coordinate: CLLocationCoordinate2D) {
        distanceLabel.text = getDistanceString(coordinate)
    }
    
}


