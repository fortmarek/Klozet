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
    
    let listCellStackView = UIStackView()
    let toiletImageView = UIImageView()
    let mainAddressLabel = UILabel()
    let subaddressLabel = UILabel()
    let distanceLabel = UILabel()
    let priceLabel = UILabel()
    let openLabel = UILabel()
    var openLabelWidthAnchor: NSLayoutConstraint?
    
    var locationDelegate: UserLocation?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        listCellStackView.axis = .horizontal
        listCellStackView.spacing = 15
        listCellStackView.alignment = .top
        listCellStackView.isLayoutMarginsRelativeArrangement = true
        listCellStackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        addSubview(listCellStackView)
        listCellStackView.pinToViewHorizontally(self)
        listCellStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let imageBackground = UIView()
        imageBackground.layer.cornerRadius = 10
        imageBackground.backgroundColor = .mainOrange
        listCellStackView.addSubview(imageBackground)
        
        toiletImageView.setHeightAndWidthAnchorToConstant(60)
        toiletImageView.clipsToBounds = true
        listCellStackView.addArrangedSubview(toiletImageView)
        
        imageBackground.pinToView(toiletImageView)
        
        let mainInfoStackView = UIStackView()
        mainInfoStackView.axis = .vertical
        mainInfoStackView.alignment = .leading
        mainInfoStackView.spacing = 0
        listCellStackView.addArrangedSubview(mainInfoStackView)
        
        mainAddressLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        mainAddressLabel.textColor = .defaultTextColor
        mainAddressLabel.textAlignment = .left
        mainInfoStackView.addArrangedSubview(mainAddressLabel)
        
        subaddressLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subaddressLabel.textColor = .coolGrey
        subaddressLabel.textAlignment = .left
        mainInfoStackView.addArrangedSubview(subaddressLabel)
        
        distanceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        distanceLabel.textColor = .coolGrey
        distanceLabel.textAlignment = .left
        mainInfoStackView.addArrangedSubview(distanceLabel)
        
        openLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        listCellStackView.addArrangedSubview(openLabel)
        openLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        openLabel.pinToViewVertically(listCellStackView)
        openLabelWidthAnchor = openLabel.widthAnchor.constraint(equalToConstant: 20)
        openLabelWidthAnchor?.isActive = true
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        //Same background color for image when selected / highlighted
//        imageBackground.backgroundColor = .mainOrange
//
//    }
//
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        imageBackground.backgroundColor = .mainOrange
//    }
    
    
    func fillCellData(_ toilet: Toilet) {
        setOpenLabel(toilet)
        setDistanceLabel(toilet.coordinate)
        setImage(toiletId: toilet.toiletId)
        
        mainAddressLabel.text = toilet.title
        subaddressLabel.isHidden = toilet.subtitle?.isEmpty ?? true
        subaddressLabel.text = toilet.subtitle
    }
    
    
    
    fileprivate func setOpenLabel(_ toilet: Toilet) {
        let openText: String
        //Is toilet open
        if isToiletOpen(toilet) {
            openText = "Open".localized
            openLabel.textColor = .vibrantGreen
        }
        
        //Toilet is not open
        else {
            openText = "Closed".localized
            openLabel.textColor = .watermelon
        }
        openLabel.text = openText
        
        let proxyOpenLabel = UILabel()
        proxyOpenLabel.font = openLabel.font
        proxyOpenLabel.text = openText
        proxyOpenLabel.sizeToFit()
        openLabelWidthAnchor?.constant = proxyOpenLabel.frame.width
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
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

