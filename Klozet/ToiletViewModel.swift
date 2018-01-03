//
//  ToiletViewModel.swift
//  Klozet
//
//  Created by Marek Fořt on 11/29/17.
//  Copyright © 2017 Marek Fořt. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreLocation
import MapKit


protocol ToiletViewModeling {
    func getToilets() -> SignalProducer<[Toilet], ConnectionError>
    var toilets: MutableProperty<[Toilet]> {get}
}

class ToiletViewModel: APIService, ToiletViewModeling {

    var directionsDelegate: DirectionsDelegate?
    var toilets: MutableProperty<[Toilet]> = MutableProperty([])
    var toiletsForList: MutableProperty<[Toilet]> = MutableProperty([])
    
    
    func getToilets() -> SignalProducer<[Toilet], ConnectionError> {
        return SignalProducer<[Toilet], ConnectionError> { [weak self] sink, disposable in
            guard let languageCode = NSLocale.current.languageCode else {return}
                let language = languageCode == "cs" ? "cs" : "en"
                self?.getCodableStruct(subpath: language, codableType: Toilets.self).startWithResult { result in
                guard let toilets = result.value?.toilets else {sink.send(error: .DecodeError); return}
                self?.toilets.value = toilets
                sink.send(value: toilets)
                sink.sendCompleted()
            }
        }
    }
 
    private func setupBindings() {
        toilets.producer.startWithValues { [weak self] toilets in
            self?.orderToilets(toilets)
        }
    }
    
    private func orderToilets(_ toilets: [Toilet]) {
        guard let directionsDelegate = self.directionsDelegate else {return}
        self.toiletsForList.value = toilets.sorted(by: {
            directionsDelegate.getDistance($0.coordinate) < directionsDelegate.getDistance($1.coordinate)
        })
    }
    
}
