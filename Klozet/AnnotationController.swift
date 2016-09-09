//
//  AnnotationController.swift
//  Klozet
//
//  Created by Marek Fořt on 09/09/16.
//  Copyright © 2016 Marek Fořt. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol AnnotationController {
    var toilets: Array<Toilet> { get set }
    var toiletsNotOpen: Array<Toilet> { get set }
    var mapView: MKMapView! { get }
}
