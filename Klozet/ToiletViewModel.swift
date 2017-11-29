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


protocol ToiletViewModeling {
    func getToilets() -> SignalProducer<Toilet, ConnectionError>
    var toilets: MutableProperty<[Toilet]> {get}
    var toiletAnnotations: MutableProperty<[MKAnnotation]> {get}
}

class ToiletViewModel: APIService, ToiletViewModeling {
    
    var toilets: MutableProperty<[Toilet]> = MutableProperty([])
    var toiletAnnotations: MutableProperty<[MKAnnotation]> = MutableProperty([])
    
    func getToilets() -> SignalProducer<[Toilet], ConnectionError> {
        return SignalProducer<[Toilet], ConnectionError> { [weak self] sink, disposable in
            guard let languageCode = NSLocale.current.languageCode else {return}
            let language = languageCode == "cs" ? "cs" : "en"
            self?.getCodableStruct(subpath: subpath, codableType: Toilets.self).startWithResult { result in
                guard let toilets = result.value?.toilets else {sink.send(error: .DecodeError); return}
                self?.toilets.value = courses
                sink.send(value: toilets)
                sink.sendCompleted()
            }
        }
    }
    
    private func setupBindings() {
        
    }
}
