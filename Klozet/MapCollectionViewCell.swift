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
        
        guard let userLocation = locationManager.location else {return}
        let addToiletAnnotation = AddToiletAnnotation(coordinate: userLocation.coordinate)
        mapView.addAnnotation(addToiletAnnotation)
        
        
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        let editMapCellStackView = UIStackView()
        editMapCellStackView.axis = .horizontal
        editMapCellStackView.alignment = .center
        editMapCellStackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 18)
        editMapCellStackView.isLayoutMarginsRelativeArrangement = true
        mapStackView.addArrangedSubview(editMapCellStackView)
        editMapCellStackView.heightAnchor.constraint(equalToConstant: 53).isActive = true
        
        let editMapLabel = UILabel()
        editMapLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        editMapLabel.textColor = .defaultTextColor
        editMapLabel.textAlignment = .left
        editMapLabel.text = "Edit map pin"
        editMapCellStackView.addArrangedSubview(editMapLabel)
        
        let chevron = UIImageView(image: UIImage(asset: Asset.backChevron))
        editMapCellStackView.addArrangedSubview(chevron)
        chevron.widthAnchor.constraint(equalToConstant: 9).isActive = true
        
        addSeparator()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView()
        annotationView.image = UIImage(asset: Asset.pin)
        
        return annotationView
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class AddToiletAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
