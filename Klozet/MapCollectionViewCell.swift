//
//  MapCollectionViewCell.swift
//  Klozet
//
//  Created by Marek Fořt on 1/5/18.
//  Copyright © 2018 Marek Fořt. All rights reserved.
//

import UIKit
import MapKit

class MapCollectionViewCell: UICollectionViewCell, UserLocation, Separable {
    
    var separatorView: UIView = UIView()
    var locationManager = CLLocationManager()
    var mapView = MKMapView()
    var toilet: Toilet?
    let editMapCellStackView = TappableCellView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        locationManager.startUpdatingLocation()
        
        
        let mapStackView = UIStackView()
        mapStackView.axis = .vertical
        addSubview(mapStackView)
        mapStackView.pinToViewHorizontally(self)
        mapStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapStackView.addArrangedSubview(mapView)
        
        
        let toiletPinImageView = UIImageView()
        toiletPinImageView.image = UIImage(asset: Asset.pin)
        addSubview(toiletPinImageView)
        toiletPinImageView.centerInView(mapView)
        
        
        
        editMapCellStackView.cellViewLabel.text = "Edit map pin"
        mapStackView.addArrangedSubview(editMapCellStackView)
        
        setToiletPositionToCurrentIfNone()
        
        addSeparator()
        
    }
    
    private func setToiletPositionToCurrentIfNone() {
        guard toilet?.coordinate.latitude == 0.0, let userLocation = getUserLocation() else {return}
        toilet?.coordinate = userLocation.coordinate
    }
    
    func centerToToilet() {
        setToiletPositionToCurrentIfNone()
        guard let toilet = self.toilet else {return}
        let region = MKCoordinateRegion(center: toilet.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: false)
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

